import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';

class CoinEffect extends SpriteComponent with HasGameReference<CatDefenseGame> {
  CoinEffect({required Vector2 position})
    : super(position: position, size: Vector2(40, 40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/CoinIcon.png');

    add(
      MoveByEffect(
        Vector2(0, -50),
        EffectController(duration: 0.8, curve: Curves.easeOut),
      ),
    );

    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.8, curve: Curves.easeIn),
        onComplete: () => removeFromParent(),
      ),
    );
  }
}
