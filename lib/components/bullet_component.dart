import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:cat_defense/components/enemy_component.dart';
import 'package:cat_defense/components/hit_effect.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/managers/run_manager.dart';

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
         size: Vector2(95, 65),
         position: startPosition,
         anchor: Anchor.center,
         priority: 20,
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

    final diff = target.absolutePosition - absolutePosition;
    final distance = diff.length;
    final step = speed * dt;

    if (distance <= step) {
      _impact(target);
      return;
    }

    final direction = diff / distance;
    position += direction * step;
    angle = direction.angleToSigned(Vector2(1, 0)) * -1;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) _impact(other);
  }

  void _impact(EnemyComponent enemy) {
    if (!isMounted || enemy.state == EnemyState.dead) return;

    double damage = data.damage;

    // Perk: Heavy Bullets
    if (RunManager.instance.activePerks.contains('heavy_bullets')) {
      damage *= 1.2;
    }

    enemy.takeDamage(damage);

    // Perk: Bounty Hunter (Partial implementation here, mainly in die())
    game.coins.value += 2;

    game.add(HitEffect(position: enemy.absolutePosition.clone()));
    removeFromParent();
  }
}
