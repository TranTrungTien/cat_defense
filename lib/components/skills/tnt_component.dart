import 'package:flame/components.dart';
import '../enemy_component.dart';
import '../hit_effect.dart';
import '../../cat_defense_game.dart';

class TntComponent extends SpriteComponent with HasGameReference<CatDefenseGame> {
  double damage = 200;
  double explosionRadius = 250;
  double fuseTime = 2.0;

  TntComponent({required Vector2 position}) : super(
    position: position,
    size: Vector2(100, 100),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/AddonIcon2.png'); // Placeholder icon cho TNT
    
    // Đếm ngược nổ
    add(TimerComponent(
      period: fuseTime,
      onTick: explode,
    ));
  }

  void explode() {
    // Hiệu ứng nổ
    game.add(HitEffect(position: position.clone())..size = Vector2(300, 300));
    
    // Gây sát thương diện rộng
    final enemies = game.children.whereType<EnemyComponent>();
    for (final enemy in enemies) {
      if (position.distanceTo(enemy.position) <= explosionRadius) {
        enemy.takeDamage(damage);
      }
    }
    
    removeFromParent();
  }
}
