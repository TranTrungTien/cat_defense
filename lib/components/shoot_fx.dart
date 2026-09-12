import 'package:flame/components.dart';
import '../cat_defense_game.dart';

class ShootFx extends SpriteAnimationComponent with HasGameReference<CatDefenseGame> {
  ShootFx({required Vector2 position})
      : super(
          position: position,
          size: Vector2(80, 80),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    final sprites = await Future.wait(
      List.generate(15, (i) => game.loadSprite('assets/Png/ShootFx/Fx2-animation_${i.toString().padLeft(2, '0')}.png')),
    );
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.03, loop: false);
  }
}
