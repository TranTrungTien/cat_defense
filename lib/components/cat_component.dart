import 'dart:ui';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flutter/material.dart' hide Color, Paint, Canvas;
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';
import 'package:cat_defense/components/enemy_component.dart';
import 'package:cat_defense/components/bullet_component.dart';
import 'package:cat_defense/components/spine_component.dart';
import 'package:cat_defense/components/shoot_fx.dart';
import 'package:cat_defense/components/hazard_component.dart';
import 'package:cat_defense/managers/run_manager.dart';

enum CatState { idle, shoot, knockedOut }

class CatComponent extends SpineComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final CatLevelData data;
  final bool isOnWall;
  final bool isGhost;
  double lastFireTime = 0;

  // New fields for Merge Cats: Endless Outpost
  double stability = 100.0;
  double maxStability = 100.0;
  bool isKnockedOut = false;
  double knockOutTimer = 0.0;
  double skillCooldownRemaining = 0.0;

  double opacity = 1.0;
  AtlasFlutter? _ownedAtlas;
  SkeletonData? _ownedSkeleton;

  CatComponent({
    required this.data,
    required this.isOnWall,
    this.isGhost = false,
  }) : super(anchor: Anchor.center, scale: Vector2(1.1, 1.1));

  @override
  Future<void> onLoad() async {
    final pool = game.catSpinePool[data.level];

    if (pool != null) {
      initSpine(SkeletonDrawableFlutter(pool.$1, pool.$2, false));
    } else {
      final atlas = await AtlasFlutter.fromAsset(data.atlasPath);
      final skeleton = await SkeletonDataFlutter.fromAsset(
        atlas,
        data.jsonPath,
      );
      _ownedAtlas = atlas;
      _ownedSkeleton = skeleton;
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation(['Idle', 'idle'], loop: true);

    if (!isGhost) {
      add(RectangleHitbox(size: size * 0.7, position: size * 0.15));
    }
  }

  @override
  void onMount() {
    super.onMount();
    _fitFeetIntoSlot();
  }

  void _fitFeetIntoSlot() {
    final p = parent;
    if (p is! PositionComponent) return;

    final pad = isOnWall
        ? GameLayout.wallFootPadding
        : GameLayout.gridFootPadding;
    final visualH = size.y * scale.y;
    position = Vector2(
      p.size.x / 2 + data.visualOffsetX,
      p.size.y - pad - visualH / 2 + data.visualOffsetY,
    );
  }

  @override
  void render(Canvas canvas) {
    if (opacity < 1.0) {
      canvas.saveLayer(
        null,
        Paint()..color = Colors.white.withAlpha((opacity * 255).toInt()),
      );
      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isGhost) {
      if (isKnockedOut) {
        _updateKnockOut(dt);
      } else {
        _updateCombat(dt);
        _updateSkillCooldown(dt);
      }
    }
  }

  void _updateKnockOut(double dt) {
    knockOutTimer -= dt;
    if (knockOutTimer <= 0) {
      isKnockedOut = false;
      stability = maxStability;
      opacity = 1.0;
      setFirstAvailableAnimation(['Idle', 'idle'], loop: true);
    }
  }

  void _updateSkillCooldown(double dt) {
    if (skillCooldownRemaining > 0) {
      skillCooldownRemaining -= dt;
    }
  }

  void takeDamage(double amount) {
    if (isKnockedOut) return;
    stability -= amount;
    if (stability <= 0) {
      _knockOut();
    }
  }

  void _knockOut() {
    isKnockedOut = true;
    knockOutTimer = 5.0; // 5 seconds recovery
    opacity = 0.5;
    setFirstAvailableAnimation(['Dead', 'dead'], loop: false);
  }

  void activateSkill() {
    if (isKnockedOut || skillCooldownRemaining > 0) return;

    final skill = getHeroSkillById(data.activeSkillId);
    if (skill == null) return;

    if (game.consumeEnergy(skill.energyCost.toDouble())) {
      skillCooldownRemaining = skill.cooldown;
      _executeSkillEffect(skill);
      game.showToast('Used ${skill.name}!');
    } else {
      game.showToast('Not enough energy!');
    }
  }

  void _executeSkillEffect(HeroSkillData skill) {
    // Animation
    final attackAnim = skeleton.data.findAnimation('Attack') ?? skeleton.data.findAnimation('attack');
    if (attackAnim != null) {
      animationState.setAnimation(0, attackAnim.name, false);
      animationState.addAnimation(0, 'Idle', true, 0);
    }

    game.add(ShootFx(position: absolutePosition + Vector2(data.muzzleX, data.muzzleY)));

    switch (skill.id) {
      case 'bullet_storm':
        // Implementation: Temporary fire rate buff
        // In a real scenario we'd use a temporary data modifier
        // For simplicity, we just set a flag or local variable
        // Placeholder for buff
        break;

      case 'cluster_bomb':
        final target = _findNearestEnemy();
        if (target != null) {
          game.add(BulletComponent(
            startPosition: absolutePosition,
            target: target,
            data: data,
          )..speed = 400); // Slower projectile for "bomb" feel
        }
        break;

      case 'deadeye':
        final eliteTarget = _findTargetByPriority(game.cachedEnemies, 1000, [(e) => e.data.isBoss]);
        if (eliteTarget != null) {
          eliteTarget.takeDamage(skill.damage ?? 500);
          game.add(ShootFx(position: eliteTarget.absolutePosition));
        }
        break;

      case 'chain_lightning':
        _executeChainLightning(skill);
        break;

      case 'fire_bomb':
        final target = _findNearestEnemy();
        if (target != null) {
          game.add(HazardComponent(
            type: 'oil',
            position: target.position.clone(),
            size: Vector2(150, 150),
            duration: skill.duration ?? 4.0,
          ));
          _applyAoE(target.position, skill.radius ?? 100, (e) => e.applyStatusEffect('burn', skill.duration ?? 4));
        }
        break;

      case 'blizzard':
        for (final enemy in game.cachedEnemies) {
          enemy.applyStatusEffect('freeze', skill.duration ?? 3.0);
        }
        break;

      case 'tesla_storm':
        for (final enemy in game.cachedEnemies) {
          enemy.takeDamage(skill.damage ?? 60);
          enemy.applyStatusEffect('shock', 3.0);
        }
        break;
    }
  }

  void _executeChainLightning(HeroSkillData skill) {
    var targets = game.cachedEnemies.where((e) => e.absolutePosition.distanceTo(absolutePosition) < 500).toList();
    targets.sort((a, b) => a.absolutePosition.distanceTo(absolutePosition).compareTo(b.absolutePosition.distanceTo(absolutePosition)));

    for (var i = 0; i < min(3, targets.length); i++) {
      targets[i].takeDamage(skill.damage ?? 40);
      targets[i].applyStatusEffect('shock', 2.0);
    }
  }

  void _applyAoE(Vector2 center, double radius, void Function(EnemyComponent) action) {
    for (final enemy in game.cachedEnemies) {
      if (enemy.position.distanceTo(center) <= radius) {
        action(enemy);
      }
    }
  }

  EnemyComponent? _findNearestEnemy() {
    EnemyComponent? nearest;
    double minDist = double.infinity;
    for (final enemy in game.cachedEnemies) {
      final dist = absolutePosition.distanceTo(enemy.absolutePosition);
      if (dist < minDist) {
        minDist = dist;
        nearest = enemy;
      }
    }
    return nearest;
  }

  void _updateCombat(double dt) {
    lastFireTime += dt;

    // Synergy Check: Military synergy increases fire rate
    double multiplier = 1.0;

    // Perk: Rapid Fire
    if (RunManager.instance.activePerks.contains('rapid_fire')) {
      multiplier *= 1.15;
    }

    if (data.synergyTags.contains(SynergyTag.military)) {
      final militaryCount = game.world.children.whereType<CatComponent>().where((c) => c.data.synergyTags.contains(SynergyTag.military)).length;
      if (militaryCount >= 3) multiplier *= 1.2;
    }

    if (lastFireTime >= (data.fireRate / multiplier)) {
      final enemies = game.cachedEnemies.where(
        (e) => e.hp > 0 && e.position.x > absolutePosition.x,
      ).toList();

      EnemyComponent? target;
      double range = isOnWall ? data.range * 1.5 : data.range;

      if (data.branch == CatBranch.marksman || data.synergyTags.contains(SynergyTag.precision)) {
        // Marksman prioritization: Elite > Ranged > Closest
        target = _findTargetByPriority(enemies, range, [
          (e) => e.data.isBoss,
          (e) => e.data.role == EnemyRole.ranged || e.data.role == EnemyRole.support,
        ]);
      } else {
        // Default: Closest to castle
        double minX = double.infinity;
        for (final enemy in enemies) {
          final distance = absolutePosition.distanceTo(enemy.position);

          // Modifier: Night Invasion reduces range
          double effectiveRange = range;
          if (RunManager.instance.activeModifiers.contains('night_invasion')) {
            effectiveRange *= 0.7;
          }

          if (distance < effectiveRange && enemy.position.x < minX) {
            minX = enemy.position.x;
            target = enemy;
          }
        }
      }

      if (target != null) {
        fireBullet(target);
        lastFireTime = 0;
      }
    }
  }

  EnemyComponent? _findTargetByPriority(List<EnemyComponent> enemies, double range, List<bool Function(EnemyComponent)> priorities) {
    for (final priorityTest in priorities) {
      EnemyComponent? best;
      double minX = double.infinity;
      for (final enemy in enemies) {
        if (priorityTest(enemy) && absolutePosition.distanceTo(enemy.position) < range) {
          if (enemy.position.x < minX) {
            minX = enemy.position.x;
            best = enemy;
          }
        }
      }
      if (best != null) return best;
    }

    // Fallback to closest
    EnemyComponent? closest;
    double minX = double.infinity;
    for (final enemy in enemies) {
      if (absolutePosition.distanceTo(enemy.position) < range && enemy.position.x < minX) {
        minX = enemy.position.x;
        closest = enemy;
      }
    }
    return closest;
  }

  void fireBullet(EnemyComponent target) {
    final shootAnim =
        skeleton.data.findAnimation('Shoot') ??
        skeleton.data.findAnimation('shoot') ??
        skeleton.data.findAnimation('Attack') ??
        skeleton.data.findAnimation('attack');
    if (shootAnim != null) {
      animationState.setAnimation(0, shootAnim.name, false);
      animationState.addAnimation(0, 'Idle', true, 0);
    }

    final bulletPos = absolutePosition + Vector2(data.muzzleX, data.muzzleY);
    game.add(ShootFx(position: bulletPos));
    game.add(
      BulletComponent(startPosition: bulletPos, target: target, data: data),
    );
  }

  @override
  void onRemove() {
    disposeSpine();
    _ownedSkeleton?.dispose();
    _ownedAtlas?.dispose();
    super.onRemove();
  }
}
