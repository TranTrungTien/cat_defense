import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';
import 'package:cat_defense/components/castle_component.dart';
import 'package:cat_defense/components/spine_component.dart';
import 'package:cat_defense/components/coin_effect.dart';

enum EnemyState { walk, attack, dead }

class EnemyComponent extends SpineComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final EnemyTypeData data;
  late double hp;
  static final _random = Random();
  EnemyState _state = EnemyState.walk;
  TimerComponent? _attackTimer;
  AtlasFlutter? _ownedAtlas;
  SkeletonData? _ownedSkeleton;

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
      _ownedAtlas = atlas;
      _ownedSkeleton = skeleton;
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation([
      'Walking',
      'Walk',
      'walking',
      'walk',
    ], loop: true);

    position = Vector2(
      CatDefenseGame.logicalSize.x + 50,
      GameLayout.enemySpawnMinY +
          _random.nextDouble() *
              (GameLayout.enemySpawnMaxY - GameLayout.enemySpawnMinY),
    );

    final widthRatio = data.isBoss ? 0.4 : 0.8;
    final heightRatio = data.isBoss ? 0.6 : 0.8;
    final hitboxSize = Vector2(size.x * widthRatio, size.y * heightRatio);

    add(
      RectangleHitbox(
        size: hitboxSize,
        position: Vector2(
          (size.x - hitboxSize.x) / 2,
          (size.y - hitboxSize.y) / 2,
        ),
      ),
    );
    game.registerEnemy(this);
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

      _attackTimer = TimerComponent(
        period: 1.5,
        repeat: true,
        onTick: () {
          if (_state == EnemyState.attack && other.isMounted) {
            other.takeDamage(10);
          }
        },
      );
      add(_attackTimer!);
    }
  }

  void takeDamage(double amount) {
    if (_state == EnemyState.dead) return;
    hp -= amount;
    if (hp <= 0) die();
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is CastleComponent && _state == EnemyState.attack) {
      _stopAttacking();
      _state = EnemyState.walk;
      setFirstAvailableAnimation([
        'Walking',
        'Walk',
        'walking',
        'walk',
      ], loop: true);
    }
  }

  void die() {
    _stopAttacking();
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
    _stopAttacking();
    game.unregisterEnemy(this);
    disposeSpine();
    _ownedSkeleton?.dispose();
    _ownedAtlas?.dispose();
    super.onRemove();
    game.checkWinCondition();
  }

  void _stopAttacking() {
    _attackTimer?.removeFromParent();
    _attackTimer = null;
  }
}
