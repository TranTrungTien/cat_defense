import 'package:flame/components.dart';
import '../hit_effect.dart';
import '../../cat_defense_game.dart';
import '../enemy_component.dart';

class TntComponent extends SpriteComponent
    with HasGameReference<CatDefenseGame> {
  double damage = 200;
  double explosionRadius = 250;
  double fuseTime = 2.0;

  TntComponent({required Vector2 position})
    : super(position: position, size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/AddonIcon2.png');
    add(TimerComponent(period: fuseTime, onTick: explode));
  }

  void explode() {
    game.add(HitEffect(position: position.clone())..size = Vector2(400, 400));

    final enemies = List<EnemyComponent>.of(game.cachedEnemies);
    for (final enemy in enemies) {
      if (enemy.isMounted &&
          position.distanceTo(enemy.position) <= explosionRadius) {
        enemy.takeDamage(damage);
      }
    }

    removeFromParent();
  }
}
