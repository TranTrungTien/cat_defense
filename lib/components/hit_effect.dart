import 'package:flame/components.dart';
import '../cat_defense_game.dart';

class HitEffect extends SpriteAnimationComponent
    with HasGameReference<CatDefenseGame> {
  HitEffect({required Vector2 position, Vector2? effectSize})
    : super(
        position: position,
        size: effectSize ?? Vector2(150, 150),
        anchor: Anchor.center,
        removeOnFinish: true,
      );

  @override
  Future<void> onLoad() async {
    final frames = game.fxCache['explosion'];
    if (frames == null) {
      removeFromParent();
      return;
    }
    animation = SpriteAnimation.spriteList(frames, stepTime: 0.04, loop: false);
  }
}
