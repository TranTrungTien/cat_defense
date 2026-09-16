import 'package:flame/components.dart';
import 'package:cat_defense/cat_defense_game.dart';

class ShootFx extends SpriteAnimationComponent
    with HasGameReference<CatDefenseGame> {
  ShootFx({required Vector2 position})
    : super(
        position: position,
        size: Vector2(120, 120),
        anchor: Anchor.center,
        removeOnFinish: true,
      );

  @override
  Future<void> onLoad() async {
    final frames = game.fxCache['shoot'];
    if (frames == null) {
      removeFromParent();
      return;
    }
    animation = SpriteAnimation.spriteList(frames, stepTime: 0.03, loop: false);
  }
}
