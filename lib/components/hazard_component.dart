import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/components/enemy_component.dart';

class HazardComponent extends SpriteComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final String type;
  final double duration;
  double _timer = 0;

  HazardComponent({
    required this.type,
    required Vector2 position,
    required Vector2 size,
    this.duration = 10.0,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    priority = 1;
    final spritePath = type == 'oil'
        ? 'assets/Png/Ui/AddonIcon2.png'
        : 'assets/Png/Ui/AddonIcon1.png'; // Placeholders
    sprite = await game.loadSprite(spritePath);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= duration) removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) {
      other.applyStatusEffect(type, duration - _timer);
      if (type == 'oil') other.applyStatusEffect('slow', duration - _timer);
      if (type == 'water') other.applyStatusEffect('wet', duration - _timer);
    }
  }
}
