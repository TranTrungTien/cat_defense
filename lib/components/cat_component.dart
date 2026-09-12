import 'dart:ui';
import 'package:flame/components.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flutter/material.dart' hide Color, Paint, Canvas;
import '../cat_defense_game.dart';
import '../game_data.dart';
import 'enemy_component.dart';
import 'bullet_component.dart';
import 'spine_component.dart';
import 'shoot_fx.dart';
import 'coin_effect.dart';

enum CatState { idle, shoot }

class CatComponent extends SpineComponent with HasGameReference<CatDefenseGame> {
  final CatLevelData data;
  final bool isOnWall; 
  double lastFireTime = 0;
  
  double opacity = 1.0; 

  CatComponent({required this.data, required this.isOnWall}) : super(
    anchor: Anchor.center,
    scale: Vector2(1.1, 1.1),
  );

  @override
  Future<void> onLoad() async {
    final pool = game.catSpinePool[data.level];
    
    if (pool != null) {
      initSpine(SkeletonDrawableFlutter(pool.$1, pool.$2, false));
    } else {
      final atlas = await AtlasFlutter.fromAsset(data.atlasPath);
      final skeleton = await SkeletonDataFlutter.fromAsset(atlas, data.jsonPath);
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation(['Idle', 'idle'], loop: true);
  }

  @override
  void render(Canvas canvas) {
    if (opacity < 1.0) {
      canvas.saveLayer(null, Paint()..color = Colors.white.withAlpha((opacity * 255).toInt()));
      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Luôn ưu tiên tấn công nếu có kẻ địch trong tầm bắn
    _updateCombat(dt);
  }

  void _updateCombat(double dt) {
    lastFireTime += dt;
    if (lastFireTime >= data.fireRate) {
      // Tìm kẻ địch trên toàn bản đồ (hoặc giới hạn tầm bắn)
      final enemies = game.children.whereType<EnemyComponent>()
          .where((e) => e.hp > 0 && e.position.x > absolutePosition.x);
          
      EnemyComponent? target;
      double minDistance = isOnWall ? 1200 : 800; // Tường bắn xa hơn

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
    final shootAnim = skeleton.data.findAnimation('Shoot') ?? skeleton.data.findAnimation('shoot');
    if (shootAnim != null) {
      animationState.setAnimation(0, shootAnim.name, false);
      animationState.addAnimation(0, 'Idle', true, 0);
    }
    
    // Bắn đạn từ vị trí của mèo
    final bulletPos = absolutePosition + Vector2(40, -10);
    game.add(ShootFx(position: bulletPos));
    
    game.add(BulletComponent(
      startPosition: bulletPos,
      target: target,
      data: data,
    ));
  }

  @override
  void onRemove() {
    disposeSpine();
    super.onRemove();
  }
}
