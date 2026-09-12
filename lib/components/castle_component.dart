import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../cat_defense_game.dart';

class CastleComponent extends PositionComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  // FIX: gia hop ly, gan voi UI
  static const double repairCost = 200;
  static const double repairAmount = 300;

  double maxHp = 1000;
  double currentHp = 1000;

  CastleComponent() : super(priority: 1);

  @override
  Future<void> onLoad() async {
    size = Vector2(80, 700);
    anchor = Anchor.topCenter;
    add(RectangleHitbox());
  }

  void takeDamage(double damage) {
    if (game.isGameOver.value) return;
    currentHp -= damage;
    game.castleHp.value = (currentHp / maxHp).clamp(0, 1);
    if (currentHp <= 0) game.gameOver();
  }

  void repair() {
    if (currentHp >= maxHp) {
      game.showToast('Wall is already full HP!');
      return;
    }
    if (game.coins.value < repairCost) {
      game.showToast('Not enough coins!');
      return;
    }
    game.coins.value -= repairCost.toInt();
    currentHp = (currentHp + repairAmount).clamp(0, maxHp);
    game.castleHp.value = currentHp / maxHp;
    game.showToast('Wall repaired!');
  }

  void reset() {
    currentHp = maxHp;
    game.castleHp.value = 1.0;
  }
}
