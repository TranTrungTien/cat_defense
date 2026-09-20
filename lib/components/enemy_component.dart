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
  final int laneId;
  final Map<String, double> _status = {};
  EnemyState _state = EnemyState.walk;
  TimerComponent? _attackTimer;
  AtlasFlutter? _ownedAtlas;
  SkeletonData? _ownedSkeleton;

  EnemyState get state => _state;

  EnemyComponent({required this.data, this.laneId = 0})
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
      data.role == EnemyRole.infiltrator
          ? GameLayout.castlePosition.x + 180
          : CatDefenseGame.logicalSize.x + 50,
      GameLayout.laneY(laneId),
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
    _status.updateAll((_, t) => t - dt);
    _status.removeWhere((_, t) => t <= 0);

    if (_state != EnemyState.walk) return;
    if (hasStatus('freeze')) return;

    var spd = data.speed;
    if (hasStatus('slow') || hasStatus('oil')) spd *= 0.55;
    final drummer = game.cachedEnemies.any(
      (e) =>
          e.data.role == EnemyRole.support &&
          e.laneId == laneId &&
          e.hp > 0 &&
          e != this,
    );
    if (drummer && data.role != EnemyRole.support) spd *= 1.25;

    if (data.role == EnemyRole.ranged && position.x < 1350) {
      _state = EnemyState.attack;
      return;
    }
    position.x -= spd * dt;
  }

  void applyStatusEffect(String type, double duration) {
    _status[type] = duration;
  }

  bool hasStatus(String t) => (_status[t] ?? 0) > 0;

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
            other.takeDamage(data.attackDamage);
          }
        },
      );
      add(_attackTimer!);
    }
  }

  void takeDamage(double amount, {bool fromFront = true}) {
    if (_state == EnemyState.dead) return;
    var dmg = amount;
    if (data.role == EnemyRole.shield && fromFront) dmg *= 0.35;
    hp -= dmg;
    if (game.hasPerk('overkill') && hp < 0) {
      final extra = -hp;
      EnemyComponent? next;
      var best = double.infinity;
      for (final e in game.cachedEnemies) {
        if (e == this || e.hp <= 0 || e.laneId != laneId) continue;
        if (e.position.x < best) {
          best = e.position.x;
          next = e;
        }
      }
      next?.takeDamage(extra, fromFront: fromFront);
    }
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
    game.gainEnergy(data.isBoss ? 15 : (data.role == EnemyRole.tank ? 5 : 1));
    if (data.role == EnemyRole.siege) {
      final r = game.hasPerk('chain_reaction') ? 220.0 : 140.0;
      final boom = game.hasPerk('chain_reaction') ? 80.0 : 40.0;
      for (final e in List<EnemyComponent>.of(game.cachedEnemies)) {
        if (e != this && e.position.distanceTo(position) <= r) {
          e.takeDamage(boom, fromFront: false);
        }
      }
    }
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
  }

  void _stopAttacking() {
    _attackTimer?.removeFromParent();
    _attackTimer = null;
  }
}
