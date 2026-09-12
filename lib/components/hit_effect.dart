import 'package:flame/components.dart';
import '../cat_defense_game.dart';

class HitEffect extends SpriteAnimationComponent with HasGameReference<CatDefenseGame> {
  HitEffect({required Vector2 position}) : super(
    position: position,
    size: Vector2(60, 60),
    anchor: Anchor.center,
    removeOnFinish: true,
  );

  @override
  Future<void> onLoad() async {
    final frames = <Sprite>[];
    for (var i = 0; i <= 19; i++) {
      frames.add(await game.loadSprite('assets/Png/Explosion/ExplosionFx-Explossion_${i.toString().padLeft(2, '0')}.png'));
    }
    animation = SpriteAnimation.spriteList(frames, stepTime: 0.04, loop: false);
  }
}
