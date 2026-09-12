import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../enemy_component.dart';
import '../../cat_defense_game.dart';

class SpikesComponent extends SpriteComponent with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  double damage = 10;
  double interval = 0.5;
  double timer = 0;
  final Set<EnemyComponent> enemiesInRange = {};

  SpikesComponent({required Vector2 position}) : super(
    position: position,
    size: Vector2(80, 80),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/AddonIcon1.png'); // Placeholder icon cho Chông
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
    if (timer >= interval) {
      for (final enemy in enemiesInRange) {
        if (enemy.isMounted) {
          enemy.takeDamage(damage);
        }
      }
      timer = 0;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) {
      enemiesInRange.add(other);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is EnemyComponent) {
      enemiesInRange.remove(other);
    }
  }
}
