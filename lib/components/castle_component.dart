import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../cat_defense_game.dart';

class CastleComponent extends PositionComponent with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  double maxHp = 1000;
  double currentHp = 1000;

  CastleComponent() : super(priority: 1);

  @override
  Future<void> onLoad() async {
    // Exact dimensions and positioning for the Wall bar in Reference 1
    size = Vector2(80, 700);
    anchor = Anchor.topCenter;
    
    // Transparent area for hitbox
    add(RectangleHitbox());
  }

  void takeDamage(double damage) {
    currentHp -= damage;
    game.castleHp.value = (currentHp / maxHp).clamp(0, 1);
    if (currentHp <= 0) game.gameOver();
  }

  void repair(double amount) {
    if (game.coins.value >= 56780) { // Giá sửa tường theo ảnh
      game.coins.value -= 56780;
      currentHp = (currentHp + amount).clamp(0, maxHp);
      game.castleHp.value = currentHp / maxHp;
    }
  }
}
