import 'dart:ui';
import 'package:flame/components.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flutter/material.dart' hide Color, Paint, Canvas;
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';
import 'package:cat_defense/components/enemy_component.dart';
import 'package:cat_defense/components/bullet_component.dart';
import 'package:cat_defense/components/spine_component.dart';
import 'package:cat_defense/components/shoot_fx.dart';

enum CatState { idle, shoot }

class CatComponent extends SpineComponent
    with HasGameReference<CatDefenseGame> {
  final CatLevelData data;
  final bool isOnWall;
  final bool isGhost;
  final int laneId;
  double lastFireTime = 0;
  double skillLock = 0;
  double cooldownLeft = 0;

  double opacity = 1.0;
  AtlasFlutter? _ownedAtlas;
  SkeletonData? _ownedSkeleton;

  CatComponent({
    required this.data,
    required this.isOnWall,
    this.isGhost = false,
    this.laneId = 0,
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
    if (isGhost) return;
    if (cooldownLeft > 0) cooldownLeft -= dt;
    if (skillLock > 0) skillLock -= dt;
    _updateCombat(dt);
  }

  void _updateCombat(double dt) {
    lastFireTime += dt;
    var interval = data.fireRate;
    if (skillLock > 0) interval *= 0.45;
    if (game.hasPerk('fire_rate')) interval *= 0.82;
    if (game.countTag(SynergyTag.military) >= 3) interval *= 0.85;
    if (game.hasPerk('desperate')) {
      interval *= (0.7 + 0.3 * game.castleHp.value);
    }
    if (lastFireTime < interval) return;

    EnemyComponent? target;
    var bestX = double.infinity;
    final range = isOnWall ? data.range + 200 : data.range;

    for (final e in game.cachedEnemies) {
      if (e.hp <= 0 || e.laneId != laneId) continue;
      if (e.position.x <= absolutePosition.x) continue;
      final d = (e.position.x - absolutePosition.x).abs();
      if (d > range) continue;
      if (e.position.x < bestX) {
        bestX = e.position.x;
        target = e;
      }
    }
    if (target != null) {
      fireBullet(target);
      lastFireTime = 0;
      if (data.branch == CatBranch.gunner) game.gainEnergy(0.15);
    }
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
