import 'package:flame/components.dart';
import '../cat_defense_game.dart';

class ShootFx extends SpriteAnimationComponent
    with HasGameReference<CatDefenseGame> {
  ShootFx({required Vector2 position})
    : super(
        position: position,
        size: Vector2(80, 80),
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
