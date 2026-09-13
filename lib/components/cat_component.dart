import 'dart:ui';
import 'package:flame/components.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flutter/material.dart' hide Color, Paint, Canvas;
import '../cat_defense_game.dart';
import '../game_data.dart';
import '../config/game_layout.dart';
import 'enemy_component.dart';
import 'bullet_component.dart';
import 'spine_component.dart';
import 'shoot_fx.dart';

enum CatState { idle, shoot }

class CatComponent extends SpineComponent
    with HasGameReference<CatDefenseGame> {
  final CatLevelData data;
  final bool isOnWall;
  double lastFireTime = 0;

  double opacity = 1.0;

  CatComponent({required this.data, required this.isOnWall})
    : super(anchor: Anchor.center, scale: Vector2(1.1, 1.1));

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
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation(['Idle', 'idle'], loop: true);
  }

  /// ============================================================
  /// FEET-ANCHORING: sau khi mount (size skeleton da biet),
  /// tu canh meo trong slot cha:
  ///   - Nam giua theo chieu NGANG
  ///   - CHAN (day skeleton) cach canh duoi slot 1 khoang nho
  ///     (gridFootPadding / wallFootPadding trong GameLayout)
  /// Khong con phu thuoc vao ty le skeleton cua tung con meo.
  /// ============================================================
  @override
  void onMount() {
    super.onMount();
    _fitFeetIntoSlot();
  }

  void _fitFeetIntoSlot() {
    final p = parent;
    // Chi tu canh khi nam trong 1 slot (PositionComponent cha).
    // Quai dung chung SpineComponent nhung parent la game -> bo qua.
    if (p is! PositionComponent) return;

    final pad = isOnWall
        ? GameLayout.wallFootPadding
        : GameLayout.gridFootPadding;
    // Kich thuoc visual thuc te sau khi ap scale
    final visualH = size.y * scale.y;
    // anchor = center -> `position` là TÂM của mèo trong không gian của slot.
    // Căn giữa theo phương ngang (X) dựa trên tâm ô + độ lệch tinh chỉnh riêng của từng con.
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
    _updateCombat(dt);
  }

  void _updateCombat(double dt) {
    lastFireTime += dt;
    if (lastFireTime >= data.fireRate) {
      final enemies = game.children.whereType<EnemyComponent>().where(
        (e) => e.hp > 0 && e.position.x > absolutePosition.x,
      );

      EnemyComponent? target;
      double minDistance = isOnWall ? 1200 : 800;

      for (final enemy in enemies) {
        final distance = absolutePosition.distanceTo(enemy.position);
        if (distance < minDistance) {
          minDistance = distance;
          target = enemy;
        }
      }

      if (target != null) {
        fireBullet(target);
        lastFireTime = 0;
      }
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

    // FIX: sau khi SpineComponent ton trong anchor, absolutePosition
    // chinh la TAM visual cua meo. Dau sung = tam + muzzleOffset
    // (chinh trong game_data.dart neu con lech).
    final bulletPos = absolutePosition + Vector2(data.muzzleX, data.muzzleY);
    game.add(ShootFx(position: bulletPos));
    game.add(
      BulletComponent(startPosition: bulletPos, target: target, data: data),
    );
  }

  @override
  void onRemove() {
    disposeSpine();
    super.onRemove();
  }
}
