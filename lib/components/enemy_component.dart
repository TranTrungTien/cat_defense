import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';
import 'package:cat_defense/components/castle_component.dart';
import 'package:cat_defense/components/cat_component.dart';
import 'package:cat_defense/components/spine_component.dart';
import 'package:cat_defense/components/coin_effect.dart';
import 'package:cat_defense/components/hit_effect.dart';
import 'package:cat_defense/managers/run_manager.dart';

enum EnemyState { walk, telegraph, attack, dead }

class EnemyComponent extends SpineComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final EnemyTypeData data;
  late double hp;
  static final _random = Random();
  EnemyState _state = EnemyState.walk;
  TimerComponent? _attackTimer;
  AtlasFlutter? _ownedAtlas;
  SkeletonData? _ownedSkeleton;

  // Tactical features
  double rage = 0.0;
  double morale = 50.0;
  double skillCooldown = 0.0;
  bool isTelegraphing = false;
  double telegraphTimer = 0.0;

  // Status Effects
  final Map<String, double> statusEffects = {};
  double slowMultiplier = 1.0;

  // Ranged settings
  static const double rangedStopDistance = 600.0;

  EnemyState get state => _state;

  EnemyComponent({required this.data})
    : super(
        anchor: Anchor.center,
        scale: data.isBoss ? Vector2(2.5, 2.5) : Vector2(1.1, 1.1),
      ) {
    hp = data.hp.toDouble();
    priority = data.isBoss ? 5 : 2;
  }

  @override
  Future<void> onLoad() async {
    final pool = game.enemySpinePool[data.name];

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

    setFirstAvailableAnimation([
      'Walking',
      'Walk',
      'walking',
      'walk',
    ], loop: true);

    position = Vector2(
      CatDefenseGame.logicalSize.x + 50,
      GameLayout.enemySpawnMinY +
          _random.nextDouble() *
              (GameLayout.enemySpawnMaxY - GameLayout.enemySpawnMinY),
    );

    final widthRatio = data.isBoss ? 0.4 : 0.8;
    final heightRatio = data.isBoss ? 0.6 : 0.8;
    final hitboxSize = Vector2(size.x * widthRatio, size.y * heightRatio);

    add(
      RectangleHitbox(
        size: hitboxSize,
        position: Vector2(
          (size.x - hitboxSize.x) / 2,
          (size.y - hitboxSize.y) / 2,
        ),
      ),
    );
    game.registerEnemy(this);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state == EnemyState.dead) return;

    _updateStatusEffects(dt);
    if (skillCooldown > 0) skillCooldown -= dt;

    if (_state == EnemyState.walk) {
      bool shouldStop = false;
      if (data.role == EnemyRole.ranged) {
        // Check distance to castle
        if (position.x < GameLayout.castlePosition.x + rangedStopDistance) {
          shouldStop = true;
          _startRangedAttack();
        }
      }

      if (!shouldStop) {
        position.x -= data.speed * slowMultiplier * dt;
      }
    } else if (_state == EnemyState.telegraph) {
      telegraphTimer -= dt;
      if (telegraphTimer <= 0) {
        _executeAttack();
      }
    }
  }

  void _startRangedAttack() {
    if (_state == EnemyState.attack || _state == EnemyState.telegraph) return;

    _state = EnemyState.telegraph;
    telegraphTimer = 1.0; // 1 second telegraph
    isTelegraphing = true;

    // Play telegraph animation if exists, otherwise idle
    setFirstAvailableAnimation(['Telegraph', 'telegraph', 'Idle', 'idle'], loop: true);

    // Add a visual indicator (red flash or similar)
    // For now just console log
  }

  void _executeAttack() {
    _state = EnemyState.attack;
    setFirstAvailableAnimation(['Attack', 'attack'], loop: true);

    _attackTimer = TimerComponent(
      period: 2.0,
      repeat: true,
      onTick: () {
        if (_state == EnemyState.attack) {
          // Ranged attack hits the castle directly
          game.castle.takeDamage(5);
        }
      },
    );
    add(_attackTimer!);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if ((other is CastleComponent || other is CatComponent) && _state == EnemyState.walk) {
      if (data.role == EnemyRole.ranged) return; // Ranged handled by distance

      _state = EnemyState.attack;
      setFirstAvailableAnimation(['Attack', 'attack'], loop: true);

      _attackTimer = TimerComponent(
        period: 1.5,
        repeat: true,
        onTick: () {
          if (_state == EnemyState.attack && other.isMounted) {
            if (other is CastleComponent) {
              other.takeDamage(10);
            } else if (other is CatComponent) {
              other.takeDamage(20);
            }
          }
        },
      );
      add(_attackTimer!);
    }
  }

  void _updateStatusEffects(double dt) {
    slowMultiplier = 1.0;
    final List<String> toRemove = [];

    statusEffects.forEach((effect, duration) {
      statusEffects[effect] = duration - dt;
      if (statusEffects[effect]! <= 0) {
        toRemove.add(effect);
      } else {
        // Apply effect logic
        switch (effect) {
          case 'burn':
            double dmg = 5.0 * dt;
            if (statusEffects.containsKey('oil')) dmg *= 2.0; // Oil + Fire synergy
            takeDamage(dmg);
            break;
          case 'slow':
            slowMultiplier = statusEffects.containsKey('oil') ? 0.3 : 0.5;
            break;
          case 'shock':
            if (statusEffects.containsKey('wet')) {
               // Chain lightning logic could be triggered here
               takeDamage(10.0 * dt);
            }
            break;
        }
      }
    });

    for (final effect in toRemove) {
      statusEffects.remove(effect);
    }
  }

  void applyStatusEffect(String effect, double duration) {
    // Skill Combo logic: Ice + Explosive = Shatter
    if (effect == 'shatter' && statusEffects.containsKey('freeze')) {
      takeDamage(100.0);
      statusEffects.remove('freeze');
      return;
    }

    // Water + Electric = Shock all
    if (effect == 'shock' && statusEffects.containsKey('wet')) {
      duration *= 2;
    }

    statusEffects[effect] = duration;
  }

  void takeDamage(double amount) {
    if (_state == EnemyState.dead) return;

    double finalDmg = amount;
    // Modifier: Armored Outbreak
    if (RunManager.instance.activeModifiers.contains('armored_outbreak')) {
      finalDmg *= 0.7;
    }

    hp -= finalDmg;

    // Morale and Rage logic
    morale -= amount * 0.1;
    if (hp <= 0) die();
  }

  void applyKnockback(double force) {
    if (_state == EnemyState.dead) return;

    // Rage reduces knockback effectiveness
    double effectiveForce = force * (1.0 - (rage / 100.0)).clamp(0.2, 1.0);
    position.x += effectiveForce;

    // Increase rage after being CC'd
    rage = min(100.0, rage + 20.0);

    // Interrupt telegraphing
    if (_state == EnemyState.telegraph) {
      _state = EnemyState.walk;
      isTelegraphing = false;
      setFirstAvailableAnimation(['Walking', 'Walk'], loop: true);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if ((other is CastleComponent || other is CatComponent) && _state == EnemyState.attack) {
      _stopAttacking();
      _state = EnemyState.walk;
      setFirstAvailableAnimation([
        'Walking',
        'Walk',
        'walking',
        'walk',
      ], loop: true);
    }
  }

  void die() {
    _stopAttacking();
    _state = EnemyState.dead;
    game.score.value += 10;

    int reward = data.reward;
    if (RunManager.instance.activePerks.contains('bounty_hunter')) {
      reward = (reward * 1.1).round();
    }

    game.coins.value += reward;
    game.add(CoinEffect(position: position + Vector2(0, -30)));

    // Perk: Chain Reaction
    if (RunManager.instance.activePerks.contains('chain_reaction')) {
      _triggerChainReaction();
    }

    final deadAnim =
        skeleton.data.findAnimation('Dead') ??
        skeleton.data.findAnimation('dead');
    if (deadAnim != null) {
      final entry = animationState.setAnimation(0, deadAnim.name, false);
      entry.setListener((type, entry, event) {
        if (type == EventType.complete &&
            entry.animation.name == deadAnim.name) {
          removeFromParent();
        }
      });
    } else {
      removeFromParent();
    }
  }

  void _triggerChainReaction() {
    game.add(HitEffect(position: absolutePosition)..size = Vector2(150, 150));
    final nearby = game.cachedEnemies.where((e) => e != this && e.hp > 0 && e.position.distanceTo(position) < 100).toList();
    for (final e in nearby) {
      e.takeDamage(20);
    }
  }

  @override
  void onRemove() {
    _stopAttacking();
    game.onEnemyRemove(this);
    disposeSpine();
    _ownedSkeleton?.dispose();
    _ownedAtlas?.dispose();
    super.onRemove();
  }

  void _stopAttacking() {
    _attackTimer?.removeFromParent();
    _attackTimer = null;
  }
}
