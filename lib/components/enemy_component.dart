import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:spine_flutter/spine_flutter.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';
import 'castle_component.dart';
import 'spine_component.dart';
import 'coin_effect.dart';

enum EnemyState { walk, attack, dead }

class EnemyComponent extends SpineComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final EnemyTypeData data;
  late double hp;
  static final _random = Random();
  EnemyState _state = EnemyState.walk;

  EnemyState get state => _state;

  EnemyComponent({required this.data})
    : super(
        anchor: Anchor.center,
        scale: data.isBoss ? Vector2(2.5, 2.5) : Vector2(1.1, 1.1),
      ) {
    hp = data.hp.toDouble();
    priority = data.isBoss ? 5 : 2;
  }

  @override
  Future<void> onLoad() async {
    final pool = game.enemySpinePool[data.name];

    if (pool != null) {
      initSpine(SkeletonDrawableFlutter(pool.$1, pool.$2, false));
    } else {
      final atlas = await AtlasFlutter.fromAsset(data.atlasPath);
      final skeleton = await SkeletonDataFlutter.fromAsset(
        atlas,
        data.jsonPath,
      );
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation([
      'Walking',
      'Walk',
      'walking',
      'walk',
    ], loop: true);

    const minY = 240.0;
    const maxY = 660.0;
    position = Vector2(
      game.size.x + 50,
      minY + _random.nextDouble() * (maxY - minY),
    );

    // FIX: hitbox dat GIUA box (truoc day nam o goc (0,0) -> lech
    // so voi visual sau khi SpineComponent ton trong anchor).
    add(
      RectangleHitbox(
        size: size * 0.8,
        position: Vector2(size.x * 0.1, size.y * 0.1),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state == EnemyState.walk) {
      position.x -= data.speed * dt;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is CastleComponent && _state == EnemyState.walk) {
      _state = EnemyState.attack;
      setFirstAvailableAnimation(['Attack', 'attack'], loop: true);

      add(
        TimerComponent(
          period: 1.5,
          repeat: true,
          onTick: () {
            if (_state == EnemyState.attack && other.isMounted) {
              other.takeDamage(10);
            }
          },
        ),
      );
    }
  }

  void takeDamage(double amount) {
    if (_state == EnemyState.dead) return;
    hp -= amount;
    if (hp <= 0) die();
  }

  void die() {
    _state = EnemyState.dead;
    game.score.value += 10;
    game.coins.value += data.reward;
    game.add(CoinEffect(position: position + Vector2(0, -30)));

    final deadAnim =
        skeleton.data.findAnimation('Dead') ??
        skeleton.data.findAnimation('dead');
    if (deadAnim != null) {
      final entry = animationState.setAnimation(0, deadAnim.name, false);
      entry.setListener((type, entry, event) {
        if (type == EventType.complete &&
            entry.animation.name == deadAnim.name) {
          removeFromParent();
        }
      });
    } else {
      removeFromParent();
    }
  }

  @override
  void onRemove() {
    disposeSpine();
    super.onRemove();
    game.checkWinCondition();
  }
}
