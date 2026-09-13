import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'enemy_component.dart';
import 'hit_effect.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';

class BulletComponent extends SpriteComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final Vector2 startPosition;
  final EnemyComponent target;
  final CatLevelData data;
  double speed = 800;

  BulletComponent({
    required this.startPosition,
    required this.target,
    required this.data,
  }) : super(
         size: Vector2(65, 35),
         position: startPosition,
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(data.bulletSprite);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!target.isMounted || target.state == EnemyState.dead) {
      removeFromParent();
      return;
    }

    final direction = (target.position - position).normalized();
    position += direction * speed * dt;
    angle = direction.angleToSigned(Vector2(1, 0)) * -1;

    if (position.distanceTo(target.position) < 20) {
      target.takeDamage(data.damage);
      game.coins.value += 2; // Tấn công ra vàng (PvZ style mod)
      game.add(HitEffect(position: position.clone()));
      removeFromParent();
    }
  }
}
