# Project Context for AI Study

---

## Directory Structure (`lib/`)

```
lib/
├── components
│   ├── skills
│   │   ├── spikes_component.dart
│   │   └── tnt_component.dart
│   ├── bullet_component.dart
│   ├── castle_component.dart
│   ├── cat_component.dart
│   ├── coin_effect.dart
│   ├── enemy_component.dart
│   ├── hit_effect.dart
│   ├── placement_slot.dart
│   ├── shoot_fx.dart
│   └── spine_component.dart
├── config
│   └── game_layout.dart
├── managers
│   └── player_data_manager.dart
├── models
│   └── player_data.dart
├── screens
│   ├── game_screen.dart
│   ├── landing_screen.dart
│   ├── level_map_screen.dart
│   └── shop_screen.dart
├── ui
│   ├── daily_reward_dialog.dart
│   ├── game_ui.dart
│   ├── lose_dialog.dart
│   ├── pause_dialog.dart
│   ├── settings_dialog.dart
│   └── win_dialog.dart
├── cat_defense_game.dart
├── game_data.dart
└── main.dart
```

## `pubspec.yaml`
```yaml
name: cat_defense
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.11.0

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter
  flame: ^1.18.0
  flame_audio: ^2.2.0
  flame_spine: ^0.3.1+6
  spine_flutter: ^4.2.0
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.5.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true

  assets:
    - assets/layout.json
    - assets/Png/Characters/
    - assets/Png/Enemies/
    - assets/Png/Area/
    - assets/Png/Ui/
    - assets/Png/Bullets/
    - assets/Png/Explosion/
    - assets/Png/ShootFx/
    - assets/Png/Cat_Guardian/
    - assets/Json_Atlas/Cat_Characters/Cat1/
    - assets/Json_Atlas/Cat_Characters/Cat2/
    - assets/Json_Atlas/Cat_Characters/Cat3/
    - assets/Json_Atlas/Cat_Characters/Cat4/
    - assets/Json_Atlas/Cat_Characters/Cat5/
    - assets/Json_Atlas/Cat_Characters/Cat6/
    - assets/Json_Atlas/Cat_Characters/Cat7/
    - assets/Json_Atlas/Cat_Characters/Cat8/
    - assets/Json_Atlas/Cat_Characters/Cat9/
    - assets/Json_Atlas/Cat_Characters/Cat10/
    - assets/Json_Atlas/Cat_Characters/Cat11/
    - assets/Json_Atlas/Cat_Characters/Cat12/
    - assets/Json_Atlas/Cat_Characters/Cat13/
    - assets/Json_Atlas/Cat_Characters/Cat14/
    - assets/Json_Atlas/Cat_Characters/Cat15/
    - assets/Json_Atlas/Enemies/Enemy_Reg_1/
    - assets/Json_Atlas/Enemies/Enemy_Reg_2/
    - assets/Json_Atlas/Enemies/Enemy_Reg_3/
    - assets/Json_Atlas/Enemies/Enemy_Reg_4/
    - assets/Json_Atlas/Enemies/Enemy_Reg_5/
    - assets/Json_Atlas/Enemies/Enemy_Reg_6/
    - assets/Json_Atlas/Enemies/Enemy_Reg_7/
    - assets/Json_Atlas/Enemies/Enemy_Reg_8/
    - assets/Json_Atlas/Enemies/Enemy_Boss_1/
    - assets/Json_Atlas/Enemies/Enemy_Boss_2/
    - assets/Json_Atlas/Enemies/Enemy_Boss_3/
    - assets/Json_Atlas/Enemies/Enemy_Boss_4/
    - assets/Json_Atlas/Enemies/Enemy_Boss_5/
    - assets/Json_Atlas/Enemies/Enemy_Boss_6/
    - assets/Json_Atlas/Enemies/Enemy_Boss_7/
    - assets/Spine/Cat_Boxing/
    - assets/Spine/Explosion_Fx/

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
```

## Source Code

### `D:\personal\cat_defense/lib\cat_defense_game.dart`
```dart
import 'dart:async' as async;
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle, SystemChrome, SystemUiMode;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spine_flutter/spine_flutter.dart';
import 'package:cat_defense/components/bullet_component.dart';
import 'package:cat_defense/components/castle_component.dart';
import 'package:cat_defense/components/enemy_component.dart';
import 'package:cat_defense/components/placement_slot.dart';
import 'package:cat_defense/components/skills/spikes_component.dart';
import 'package:cat_defense/components/skills/tnt_component.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';

class CatDefenseGame extends FlameGame
    with HasCollisionDetection, TapCallbacks {
  static final Vector2 logicalSize = Vector2(1920, 1080);
  static const int totalWaves = 10;
  static const int initialCoins = 5000;

  static const bool showLayoutDebug = bool.fromEnvironment(
    'LAYOUT_DEBUG',
    defaultValue: false,
  );

  static const Map<String, int> skillCosts = {'spikes': 200, 'tnt': 500};

  late CastleComponent castle;
  late SpriteComponent background;

  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> coins = ValueNotifier(initialCoins);
  final ValueNotifier<double> castleHp = ValueNotifier(1.0);
  final ValueNotifier<bool> isGameOver = ValueNotifier(false);
  final ValueNotifier<int> currentWave = ValueNotifier(1);

  final ValueNotifier<CatLevelData?> selectedCatData = ValueNotifier(null);
  final ValueNotifier<PlacementSlot?> selectedSlot = ValueNotifier(null);
  final ValueNotifier<String?> selectedSkill = ValueNotifier(null);

  final ValueNotifier<Map<String, int>> skillCounts = ValueNotifier({
    'spikes': 2,
    'tnt': 3,
  });
  final ValueNotifier<String?> toast = ValueNotifier(null);

  PlacementSlot? hoveredSlot;

  final Map<String, List<Sprite>> fxCache = {};
  final Map<int, (AtlasFlutter, SkeletonData)> catSpinePool = {};
  final Map<String, (AtlasFlutter, SkeletonData)> enemySpinePool = {};

  async.Timer? _toastTimer;
  TimerComponent? _waveTimer;
  int _waveGeneration = 0;
  int _pendingSpawnCount = 0;
  int _backgroundRequestId = 0;
  final List<EnemyComponent> _cachedEnemies = [];
  bool _hasRequestedFullscreen = false;

  List<EnemyComponent> get cachedEnemies => _cachedEnemies;

  double get visibleWorldWidth => camera.viewfinder.zoom > 0
      ? size.x / camera.viewfinder.zoom
      : logicalSize.x;
  double get visibleWorldHeight => camera.viewfinder.zoom > 0
      ? size.y / camera.viewfinder.zoom
      : logicalSize.y;

  @override
  Future<void> add(Component component) async {
    if (component is! CameraComponent && component is! World) {
      await world.add(component);
    } else {
      await super.add(component);
    }
  }

  @override
  Future<void> onLoad() async {
    // Khởi tạo camera tiêu chuẩn
    camera = CameraComponent();

    // Đặt vị trí camera vào tâm thế giới game (1920 / 2, 1080 / 2)
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = logicalSize / 2;

    _updateCameraZoom();

    images.prefix = '';
    await initSpineFlutter();

    await _loadLayoutConfig();
    await _preloadAssets();
    await _preloadFx();

    background = SpriteComponent()
      ..sprite = await loadSprite('assets/Png/Area/Area1.png')
      ..size = logicalSize
      ..position = Vector2.zero();
    add(background);

    currentWave.addListener(_onWaveChange);

    castle = CastleComponent()..position = GameLayout.castlePosition;
    add(castle);

    _setupPlacementSlots();
    _startWaveManager();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateCameraZoom();
  }

  /// Tính toán tỉ lệ zoom kiểu BoxFit.cover (lấy max giữa scale ngang và dọc)
  void _updateCameraZoom() {
    if (size.x <= 0 || size.y <= 0) return;
    final scaleX = size.x / logicalSize.x;
    final scaleY = size.y / logicalSize.y;
    camera.viewfinder.zoom = max(scaleX, scaleY);
  }

  Future<void> _loadLayoutConfig() async {
    try {
      final src = await rootBundle.loadString('assets/layout.json');
      GameLayout.loadFromJsonString(src);
      debugPrint('GameLayout: da load tu assets/layout.json');
    } catch (_) {
      debugPrint('GameLayout: khong co assets/layout.json — dung defaults');
      if (showLayoutDebug) {
        debugPrint(GameLayout.exportJson());
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (kIsWeb && !_hasRequestedFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      _hasRequestedFullscreen = true;
    }

    super.onTapDown(event);

    final skill = selectedSkill.value;
    if (skill == null) return;

    final localPos = camera.globalToLocal(event.canvasPosition);

    if (localPos.x < 0 ||
        localPos.x > logicalSize.x ||
        localPos.y < 0 ||
        localPos.y > logicalSize.y) {
      return;
    }

    if (localPos.x < GameLayout.castlePosition.x) {
      showToast('Place skills on the enemy side!');
      return;
    }

    final cost = skillCosts[skill] ?? 0;
    final left = skillCounts.value[skill] ?? 0;

    if (left <= 0) {
      showToast('Out of uses!');
      return;
    }
    if (coins.value < cost) {
      showToast('Not enough coins!');
      return;
    }

    coins.value -= cost;
    skillCounts.value = {...skillCounts.value, skill: left - 1};

    if (skill == 'spikes') add(SpikesComponent(position: localPos));
    if (skill == 'tnt') add(TntComponent(position: localPos));
    selectedSkill.value = null;
  }

  void showToast(String message) {
    toast.value = message;
    _toastTimer?.cancel();
    _toastTimer = async.Timer(const Duration(milliseconds: 1500), () {
      toast.value = null;
    });
  }

  Future<void> _preloadAssets() async {
    for (int i = 0; i < catLevels.length; i++) {
      final data = catLevels[i];
      final atlas = await AtlasFlutter.fromAsset(data.atlasPath);
      final skeleton = await SkeletonDataFlutter.fromAsset(
        atlas,
        data.jsonPath,
      );
      catSpinePool[data.level] = (atlas, skeleton);
    }

    for (final eData in enemyRegistry) {
      final eAtlas = await AtlasFlutter.fromAsset(eData.atlasPath);
      final eSkeleton = await SkeletonDataFlutter.fromAsset(
        eAtlas,
        eData.jsonPath,
      );
      enemySpinePool[eData.name] = (eAtlas, eSkeleton);
    }
  }

  Future<void> _preloadFx() async {
    final explosion = <Sprite>[];
    for (var i = 0; i <= 19; i++) {
      explosion.add(
        await loadSprite(
          'assets/Png/Explosion/ExplosionFx-Explossion_${i.toString().padLeft(2, '0')}.png',
        ),
      );
    }
    fxCache['explosion'] = explosion;

    final shoot = await Future.wait(
      List.generate(
        15,
        (i) => loadSprite(
          'assets/Png/ShootFx/Fx2-animation_${i.toString().padLeft(2, '0')}.png',
        ),
      ),
    );
    fxCache['shoot'] = shoot;

    for (final path in {
      'assets/Png/Bullets/Artboard_1.png',
      'assets/Png/Bullets/Artboard_1_copy.png',
      'assets/Png/Bullets/Artboard_1_copy_2.png',
    }) {
      await loadSprite(path);
    }
  }

  Future<void> _onWaveChange() async {
    if (!isMounted) return;
    final requestId = ++_backgroundRequestId;
    int bgIndex = ((currentWave.value - 1) ~/ 5) + 1;
    bgIndex = bgIndex.clamp(1, 5);
    final sprite = await loadSprite('assets/Png/Area/Area$bgIndex.png');
    if (isMounted &&
        background.isMounted &&
        requestId == _backgroundRequestId) {
      background.sprite = sprite;
    }
  }

  void _startWaveManager() {
    late final TimerComponent timer;
    timer = TimerComponent(
      period: _getWavePeriod(currentWave.value),
      onTick: () {
        timer.removeFromParent();
        if (_waveTimer == timer) _waveTimer = null;
        if (!isGameOver.value && currentWave.value <= totalWaves) {
          _spawnWave();
        }
      },
    );
    _waveTimer = timer;
    add(_waveTimer!);
  }

  double _getWavePeriod(int wave) => (8.0 - wave * 0.3).clamp(4.0, 8.0);

  void _spawnWave() {
    final waveNumber = currentWave.value;
    if (waveNumber > totalWaves) return;

    final isBossWave = waveNumber % 5 == 0;
    int enemyCount = 3 + (waveNumber * 2);

    if (isBossWave) {
      showToast('BOSS INCOMING IN 10 SECONDS!');

      add(
        TimerComponent(
          period: 10.0,
          repeat: false,
          removeOnFinish: true,
          onTick: () {
            if (!isGameOver.value && isMounted) {
              final bosses = enemyRegistry.where((e) => e.isBoss).toList();
              if (bosses.isNotEmpty) {
                final bossData = bosses[Random().nextInt(bosses.length)];
                _pendingSpawnCount++;
                add(EnemyComponent(data: bossData));
              }
            }
          },
        ),
      );

      enemyCount = (enemyCount * 0.7).toInt();
    }

    int spawnedCount = 0;

    _spawnSingleEnemy(waveNumber);
    spawnedCount++;

    if (enemyCount > 1) {
      late final TimerComponent spawnTimer;
      spawnTimer = TimerComponent(
        period: 0.8,
        repeat: true,
        removeOnFinish: true,
        onTick: () {
          if (isGameOver.value || !isMounted) {
            spawnTimer.removeFromParent();
            return;
          }

          _spawnSingleEnemy(waveNumber);
          spawnedCount++;

          if (spawnedCount >= enemyCount) {
            spawnTimer.removeFromParent();
          }
        },
      );

      add(spawnTimer);
    }
  }

  void _spawnSingleEnemy(int waveNumber) {
    final regularEnemies = enemyRegistry.where((e) => !e.isBoss).toList();
    if (regularEnemies.isEmpty) return;

    final maxType = (waveNumber / 2).floor().clamp(1, regularEnemies.length);
    final enemyData = regularEnemies[Random().nextInt(maxType)];

    _pendingSpawnCount++;
    add(EnemyComponent(data: enemyData));
  }

  void _finishSpawn(int waveNumber) {
    _pendingSpawnCount--;
    if (_pendingSpawnCount != 0 || currentWave.value != waveNumber) return;

    currentWave.value = waveNumber + 1;
    if (currentWave.value <= totalWaves && !isGameOver.value) {
      _startWaveManager();
    }
    checkWinCondition();
  }

  void checkWinCondition() {
    if (isGameOver.value || currentWave.value <= totalWaves) return;
    if (_pendingSpawnCount == 0 &&
        world.children.whereType<EnemyComponent>().isEmpty) {
      isGameOver.value = true;
      pauseEngine();
      overlays.add('WinScreen');
    }
  }

  void _setupPlacementSlots() {
    for (final def in GameLayout.slots) {
      final slot = PlacementSlot(
        layoutId: def.id,
        position: def.center - def.size / 2,
        size: def.size.clone(),
        isWallSlot: def.isWallSlot,
        isDeleteSlot: def.isDeleteSlot,
      )..priority = def.isDeleteSlot ? 30 : (def.isWallSlot ? 20 : 10);
      slot.debugMode = showLayoutDebug;
      add(slot);
    }
  }

  void gameOver() {
    if (isGameOver.value) return;
    isGameOver.value = true;
    pauseEngine();
    overlays.add('GameOver');
  }

  void registerEnemy(EnemyComponent enemy) {
    if (!_cachedEnemies.contains(enemy)) _cachedEnemies.add(enemy);
  }

  void unregisterEnemy(EnemyComponent enemy) {
    _cachedEnemies.remove(enemy);
  }

  void reset() {
    _waveGeneration++;
    _pendingSpawnCount = 0;
    _waveTimer?.removeFromParent();
    _waveTimer = null;
    score.value = 0;
    coins.value = initialCoins;
    castleHp.value = 1.0;
    isGameOver.value = false;
    currentWave.value = 1;
    selectedCatData.value = null;
    selectedSlot.value = null;
    selectedSkill.value = null;
    skillCounts.value = {'spikes': 2, 'tnt': 3};
    hoveredSlot = null;

    castle.reset();

    world.children.whereType<EnemyComponent>().forEach(
      (e) => e.removeFromParent(),
    );
    world.children.whereType<BulletComponent>().forEach(
      (b) => b.removeFromParent(),
    );
    world.children.whereType<SpikesComponent>().forEach(
      (s) => s.removeFromParent(),
    );
    world.children.whereType<TntComponent>().forEach(
      (t) => t.removeFromParent(),
    );
    world.children.whereType<PlacementSlot>().forEach((s) => s.reset());

    overlays.remove('GameOver');
    overlays.remove('Pause');
    overlays.remove('WinScreen');
    _startWaveManager();
    resumeEngine();
  }

  @override
  void onDetach() {
    _waveGeneration++;
    _waveTimer?.removeFromParent();
    _waveTimer = null;
    currentWave.removeListener(_onWaveChange);
    _toastTimer?.cancel();
    for (final pool in catSpinePool.values) {
      pool.$2.dispose();
      pool.$1.dispose();
    }
    for (final pool in enemySpinePool.values) {
      pool.$2.dispose();
      pool.$1.dispose();
    }
    super.onDetach();
  }
}
```

### `D:\personal\cat_defense/lib\components\bullet_component.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:cat_defense/components/enemy_component.dart';
import 'package:cat_defense/components/hit_effect.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';

class BulletComponent extends SpriteComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final Vector2 startPosition;
  final EnemyComponent target;
  final CatLevelData data;
  double speed = 800;

  BulletComponent({
    required this.startPosition,
    required this.target,
    required this.data,
  }) : super(
         size: Vector2(95, 65),
         position: startPosition,
         anchor: Anchor.center,
         priority: 20,
       );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(data.bulletSprite);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!target.isMounted || target.state == EnemyState.dead) {
      removeFromParent();
      return;
    }

    final diff = target.absolutePosition - absolutePosition;
    final distance = diff.length;
    final step = speed * dt;

    if (distance <= step) {
      _impact(target);
      return;
    }

    final direction = diff / distance;
    position += direction * step;
    angle = direction.angleToSigned(Vector2(1, 0)) * -1;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) _impact(other);
  }

  void _impact(EnemyComponent enemy) {
    if (!isMounted || enemy.state == EnemyState.dead) return;
    enemy.takeDamage(data.damage);
    game.coins.value += 2;
    game.add(HitEffect(position: enemy.absolutePosition.clone()));
    removeFromParent();
  }
}
```

### `D:\personal\cat_defense/lib\components\castle_component.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:cat_defense/cat_defense_game.dart';

class CastleComponent extends PositionComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  static const double repairCost = 200;
  static const double repairAmount = 300;

  double maxHp = 1000;
  double currentHp = 1000;

  CastleComponent() : super(priority: 1);

  @override
  Future<void> onLoad() async {
    size = Vector2(80, 700);
    anchor = Anchor.topCenter;
    add(RectangleHitbox());
  }

  void takeDamage(double damage) {
    if (game.isGameOver.value) return;
    currentHp -= damage;
    game.castleHp.value = (currentHp / maxHp).clamp(0, 1);
    if (currentHp <= 0) game.gameOver();
  }

  void repair() {
    if (currentHp >= maxHp) {
      game.showToast('Wall is already full HP!');
      return;
    }
    if (game.coins.value < repairCost) {
      game.showToast('Not enough coins!');
      return;
    }
    game.coins.value -= repairCost.toInt();
    currentHp = (currentHp + repairAmount).clamp(0, maxHp);
    game.castleHp.value = currentHp / maxHp;
    game.showToast('Wall repaired!');
  }

  void reset() {
    currentHp = maxHp;
    game.castleHp.value = 1.0;
  }
}
```

### `D:\personal\cat_defense/lib\components\cat_component.dart`
```dart
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flutter/material.dart' hide Color, Paint, Canvas;
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';
import 'package:cat_defense/components/enemy_component.dart';
import 'package:cat_defense/components/bullet_component.dart';
import 'package:cat_defense/components/spine_component.dart';
import 'package:cat_defense/components/shoot_fx.dart';

enum CatState { idle, shoot }

class CatComponent extends SpineComponent
    with HasGameReference<CatDefenseGame> {
  final CatLevelData data;
  final bool isOnWall;
  final bool isGhost;
  double lastFireTime = 0;

  double opacity = 1.0;
  AtlasFlutter? _ownedAtlas;
  SkeletonData? _ownedSkeleton;

  CatComponent({
    required this.data,
    required this.isOnWall,
    this.isGhost = false,
  }) : super(anchor: Anchor.center, scale: Vector2(1.1, 1.1));

  @override
  Future<void> onLoad() async {
    final pool = game.catSpinePool[data.level];

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

    setFirstAvailableAnimation(['Idle', 'idle'], loop: true);
  }

  @override
  void onMount() {
    super.onMount();
    _fitFeetIntoSlot();
  }

  void _fitFeetIntoSlot() {
    final p = parent;
    if (p is! PositionComponent) return;

    final pad = isOnWall
        ? GameLayout.wallFootPadding
        : GameLayout.gridFootPadding;
    final visualH = size.y * scale.y;
    position = Vector2(
      p.size.x / 2 + data.visualOffsetX,
      p.size.y - pad - visualH / 2 + data.visualOffsetY,
    );
  }

  @override
  void render(Canvas canvas) {
    if (opacity < 1.0) {
      canvas.saveLayer(
        null,
        Paint()..color = Colors.white.withAlpha((opacity * 255).toInt()),
      );
      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isGhost) {
      _updateCombat(dt);
    }
  }

  void _updateCombat(double dt) {
    lastFireTime += dt;
    if (lastFireTime >= data.fireRate) {
      final enemies = game.cachedEnemies.where(
        (e) => e.hp > 0 && e.position.x > absolutePosition.x,
      );

      EnemyComponent? target;
      double minDistance = isOnWall ? 1200 : 800;

      for (final enemy in enemies) {
        final distance = absolutePosition.distanceTo(enemy.position);
        if (distance < minDistance) {
          minDistance = distance;
          target = enemy;
        }
      }

      if (target != null) {
        fireBullet(target);
        lastFireTime = 0;
      }
    }
  }

  void fireBullet(EnemyComponent target) {
    final shootAnim =
        skeleton.data.findAnimation('Shoot') ??
        skeleton.data.findAnimation('shoot') ??
        skeleton.data.findAnimation('Attack') ??
        skeleton.data.findAnimation('attack');
    if (shootAnim != null) {
      animationState.setAnimation(0, shootAnim.name, false);
      animationState.addAnimation(0, 'Idle', true, 0);
    }

    final bulletPos = absolutePosition + Vector2(data.muzzleX, data.muzzleY);
    game.add(ShootFx(position: bulletPos));
    game.add(
      BulletComponent(startPosition: bulletPos, target: target, data: data),
    );
  }

  @override
  void onRemove() {
    disposeSpine();
    _ownedSkeleton?.dispose();
    _ownedAtlas?.dispose();
    super.onRemove();
  }
}
```

### `D:\personal\cat_defense/lib\components\coin_effect.dart`
```dart
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
```

### `D:\personal\cat_defense/lib\components\enemy_component.dart`
```dart
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
```

### `D:\personal\cat_defense/lib\components\hit_effect.dart`
```dart
import 'package:flame/components.dart';
import 'package:cat_defense/cat_defense_game.dart';

class HitEffect extends SpriteAnimationComponent
    with HasGameReference<CatDefenseGame> {
  HitEffect({required Vector2 position, Vector2? effectSize})
    : super(
        position: position,
        size: effectSize ?? Vector2(150, 150),
        anchor: Anchor.center,
        removeOnFinish: true,
        priority: 30,
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
```

### `D:\personal\cat_defense/lib\components\placement_slot.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';
import 'package:cat_defense/components/cat_component.dart';

class PlacementSlot extends PositionComponent
    with
        HasGameReference<CatDefenseGame>,
        TapCallbacks,
        HoverCallbacks,
        DragCallbacks {
  final String layoutId;
  final bool isWallSlot;
  final bool isDeleteSlot;
  bool isOccupied = false;
  CatComponent? residentCat;
  CatComponent? ghostCat;

  PlacementSlot({
    required this.layoutId,
    required Vector2 position,
    required Vector2 size,
    this.isWallSlot = false,
    this.isDeleteSlot = false,
  }) : super(position: position, size: size);

  bool get _isHovered => game.hoveredSlot == this;

  @override
  void update(double dt) {
    super.update(dt);

    if (isDeleteSlot) return;

    final selectedCat = game.selectedCatData.value;
    final shouldShowGhost = selectedCat != null && !isOccupied && _isHovered;

    if (shouldShowGhost) {
      if (ghostCat == null) {
        final afford = game.coins.value >= selectedCat.cost;
        ghostCat =
            CatComponent(data: selectedCat, isOnWall: isWallSlot, isGhost: true)
              ..position = size / 2
              ..opacity = afford ? 0.6 : 0.25;
        add(ghostCat!);
      } else if (ghostCat!.data.level != selectedCat.level) {
        ghostCat?.removeFromParent();
        ghostCat = null;
      }
    } else if (ghostCat != null) {
      ghostCat?.removeFromParent();
      ghostCat = null;
    }
  }

  @override
  void onHoverEnter() => game.hoveredSlot = this;

  @override
  void onHoverExit() {
    if (game.hoveredSlot == this) game.hoveredSlot = null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.hoveredSlot = this;

    if (isDeleteSlot) {
      game.selectedCatData.value = null;
      game.selectedSkill.value = null;
      game.selectedSlot.value = null;
      return;
    }

    final selectedCat = game.selectedCatData.value;

    if (selectedCat != null && !isOccupied) {
      if (game.coins.value < selectedCat.cost) {
        game.showToast('Not enough coins!');
        return;
      }
      game.coins.value -= selectedCat.cost;
      _placeCat(selectedCat);
      game.selectedCatData.value = null;
      game.selectedSlot.value = null;
    } else if (isOccupied && residentCat != null && selectedCat == null) {
      game.selectedSlot.value = this;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (game.hoveredSlot == this) game.hoveredSlot = null;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!CatDefenseGame.showLayoutDebug) return;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!CatDefenseGame.showLayoutDebug) return;
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!CatDefenseGame.showLayoutDebug) return;
    final center = position + size / 2;
    GameLayout.updateSlotCenter(layoutId, center);
    debugPrint('=== LAYOUT EXPORT ===');
    debugPrint(GameLayout.exportJson());
    game.showToast('$layoutId -> (${center.x.round()}, ${center.y.round()})');
  }

  void _placeCat(CatLevelData data) {
    final cat = CatComponent(data: data, isOnWall: isWallSlot)
      ..position = size / 2;
    add(cat);
    residentCat = cat;
    isOccupied = true;

    ghostCat?.removeFromParent();
    ghostCat = null;
  }

  void sellCat() {
    final cat = residentCat;
    if (cat == null) return;
    final refund = (cat.data.cost * 0.5).round();
    game.coins.value += refund;
    game.showToast('Sold! +$refund');
    cat.removeFromParent();
    residentCat = null;
    isOccupied = false;
    game.selectedSlot.value = null;
  }

  void upgradeCat() {
    final cat = residentCat;
    if (cat == null) return;
    final next = catLevels.where((data) => data.level == cat.data.level + 1);
    if (next.isEmpty) {
      game.showToast('Max level reached');
      return;
    }
    final upgraded = next.first;
    if (game.coins.value < cat.data.upgradeCost) {
      game.showToast('Not enough coins!');
      return;
    }
    game.coins.value -= cat.data.upgradeCost;
    cat.removeFromParent();
    final replacement = CatComponent(data: upgraded, isOnWall: isWallSlot)
      ..position = size / 2;
    add(replacement);
    residentCat = replacement;
    game.selectedSlot.value = null;
    game.showToast('Upgraded to Lv ${upgraded.level}');
  }

  void reset() {
    residentCat?.removeFromParent();
    residentCat = null;
    isOccupied = false;
    game.selectedSlot.value = null;
    ghostCat?.removeFromParent();
    ghostCat = null;
  }
}
```

### `D:\personal\cat_defense/lib\components\shoot_fx.dart`
```dart
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
```

### `D:\personal\cat_defense/lib\components\skills\spikes_component.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:cat_defense/components/enemy_component.dart';
import 'package:cat_defense/cat_defense_game.dart';

class SpikesComponent extends SpriteComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  double damage = 10;
  double interval = 0.5;
  double timer = 0;
  final Set<EnemyComponent> enemiesInRange = {};

  SpikesComponent({required Vector2 position})
    : super(position: position, size: Vector2(80, 80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(
      'assets/Png/Ui/AddonIcon1.png',
    ); // Placeholder icon cho Chông
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    enemiesInRange.removeWhere(
      (enemy) => !enemy.isMounted || enemy.state == EnemyState.dead,
    );
    timer += dt;
    if (timer >= interval) {
      for (final enemy in List<EnemyComponent>.of(enemiesInRange)) {
        enemy.takeDamage(damage);
      }
      timer = 0;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) {
      enemiesInRange.add(other);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is EnemyComponent) {
      enemiesInRange.remove(other);
    }
  }
}
```

### `D:\personal\cat_defense/lib\components\skills\tnt_component.dart`
```dart
import 'package:flame/components.dart';
import 'package:cat_defense/components/hit_effect.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/components/enemy_component.dart';

class TntComponent extends SpriteComponent
    with HasGameReference<CatDefenseGame> {
  double damage = 200;
  double explosionRadius = 250;
  double fuseTime = 2.0;

  TntComponent({required Vector2 position})
    : super(position: position, size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/AddonIcon2.png');
    add(TimerComponent(period: fuseTime, onTick: explode));
  }

  void explode() {
    game.add(HitEffect(position: position.clone())..size = Vector2(400, 400));

    final enemies = List<EnemyComponent>.of(game.cachedEnemies);
    for (final enemy in enemies) {
      if (enemy.isMounted &&
          position.distanceTo(enemy.position) <= explosionRadius) {
        enemy.takeDamage(damage);
      }
    }

    removeFromParent();
  }
}
```

### `D:\personal\cat_defense/lib\components\spine_component.dart`
```dart
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flame/components.dart';
import 'dart:ui';

/// FIX ALIGNMENT: render skeleton TON TRONG anchor cua component.
///
/// - anchor = center (mèo, quái): position = TÂM visual.
///   Đặt component tại slot.size / 2 -> mèo thật sự nằm giữa slot,
///   absolutePosition = tâm mèo -> đạn spawn đúng chỗ.
/// - anchor = topLeft: giữ nguyên hành vi cũ (skeleton căn giữa origin).
class SpineComponent extends PositionComponent {
  final BoundsProvider _boundsProvider;
  late final SkeletonDrawableFlutter _drawable;
  late final Bounds _bounds;
  bool _isInitialized = false;

  SpineComponent({
    BoundsProvider boundsProvider = const SetupPoseBounds(),
    super.position,
    super.scale,
    double super.angle = 0.0,
    Anchor super.anchor = Anchor.topLeft,
    super.children,
    super.priority,
  }) : _boundsProvider = boundsProvider;

  void initSpine(SkeletonDrawableFlutter drawable) {
    _drawable = drawable;
    _drawable.update(0);
    _bounds = _boundsProvider.computeBounds(_drawable);
    size = Vector2(_bounds.width, _bounds.height);
    _isInitialized = true;
  }

  @override
  void update(double dt) {
    if (_isInitialized) {
      _drawable.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    if (_isInitialized) {
      canvas.save();
      // Điểm đặt tâm skeleton trong local box = anchor * size
      final center = anchor.toVector2()..multiply(size);
      canvas.translate(
        center.x - _bounds.x - _bounds.width / 2,
        center.y - _bounds.y - _bounds.height / 2,
      );
      _drawable.renderToCanvas(canvas);
      canvas.restore();
    }
  }

  AnimationState get animationState => _drawable.animationState;
  AnimationStateData get animationStateData => _drawable.animationStateData;
  Skeleton get skeleton => _drawable.skeleton;

  void setFirstAvailableAnimation(List<String> names, {bool loop = true}) {
    for (final name in names) {
      final animation = skeleton.data.findAnimation(name);
      if (animation != null) {
        animationState.setAnimation(0, name, loop);
        return;
      }
    }
  }

  void disposeSpine() {
    _drawable.dispose();
  }
}
```

### `D:\personal\cat_defense/lib\config\game_layout.dart`
```dart
import 'dart:convert';
import 'package:flame/components.dart';

/// ============================================================
/// LAYOUT — 1 SLOT = 1 VỊ TRÍ ĐỘC LẬP (không còn dạng lưới hardcode)
///
/// Mỗi slot có: id + TÂM (cx, cy) + kích thước (w, h) tính bằng PIXEL
/// trong world 1920x1080 (world luôn cố định nhờ FixedResolutionViewport,
/// nên tự động đúng trên mọi màn hình vật lý).
///
/// CÓ 2 NGUỒN DỮ LIỆU (theo thứ tự ưu tiên):
///   1. assets/layout.json — nếu có, game load từ file này.
///   2. buildDefaults() — dùng nếu chưa có file json.
///
/// CÁCH CALIBRATE (làm 1 lần, ~3 phút):
///   1. CatDefenseGame.showLayoutDebug = true, chạy game.
///   2. KÉO THẢ từng slot cho trùng art (ô trắng, box cam, thùng rác).
///   3. Mỗi lần thả, toàn bộ layout in ra console dạng JSON.
///   4. Copy JSON đó → lưu thành assets/layout.json
///      (nhớ thêm 'assets/layout.json' vào pubspec).
///   5. Restart → game dùng đúng vị trí đã kéo.
///   6. Đặt showLayoutDebug = false khi release.
/// ============================================================

class SlotDef {
  final String id;
  Vector2 center;
  Vector2 size;
  final bool isWallSlot;
  final bool isDeleteSlot;

  SlotDef(
    this.id,
    this.center,
    this.size, {
    this.isWallSlot = false,
    this.isDeleteSlot = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cx': center.x.round(),
    'cy': center.y.round(),
    'w': size.x.round(),
    'h': size.y.round(),
    if (isWallSlot) 'wall': true,
    if (isDeleteSlot) 'delete': true,
  };

  factory SlotDef.fromJson(Map<String, dynamic> j) => SlotDef(
    j['id'] as String,
    Vector2((j['cx'] as num).toDouble(), (j['cy'] as num).toDouble()),
    Vector2((j['w'] as num).toDouble(), (j['h'] as num).toDouble()),
    isWallSlot: j['wall'] == true,
    isDeleteSlot: j['delete'] == true,
  );
}

class GameLayout {
  static const double worldW = 1920;
  static const double worldH = 1080;

  /// Vị trí castle (thanh cổng) — chỉ là hitbox, không vẽ gì.
  static Vector2 castlePosition = Vector2(565, 0);

  static double enemySpawnMinY = 240;
  static double enemySpawnMaxY = 660;

  /// Khoảng cách từ CHÂN mèo đến cạnh dưới của slot (pixel, world space).
  /// Chân mèo sẽ nằm CAO HƠN cạnh dưới slot đúng chừng này.
  /// Chỉnh 2 số này nếu muốn mèo đứng sát đáy hơn / cao hơn.
  static double gridFootPadding = 10;
  static double wallFootPadding = 6;

  /// Defaults đã được đo theo dấu 'X' ngưởi dùng đánh dấu trên art:
  ///   - Grid trắng: 2 cột x 4 hàng, tâm các ô bên dưới
  ///   - Wall box cam: 5 ô, cột x = 544
  ///   - Thùng rác: 1 ô
  static List<SlotDef> buildDefaults() {
    final slots = <SlotDef>[];

    const cols = [269.0, 389.0];
    const rows = [312.0, 434.0, 554.0, 664.0];
    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < cols.length; c++) {
        slots.add(
          SlotDef('g_${r}_$c', Vector2(cols[c], rows[r]), Vector2(100, 90)),
        );
      }
    }

    const wallYs = [274.0, 394.0, 514.0, 634.0, 744.0];
    for (var i = 0; i < wallYs.length; i++) {
      slots.add(
        SlotDef(
          'w_$i',
          Vector2(544, wallYs[i]),
          Vector2(105, 95),
          isWallSlot: true,
        ),
      );
    }

    slots.add(
      SlotDef(
        'delete',
        Vector2(389, 764),
        Vector2(100, 90),
        isDeleteSlot: true,
      ),
    );

    return slots;
  }

  /// Danh sách slot đang hoạt động (có thể đã bị override từ layout.json
  /// hoặc cập nhật khi kéo thả calibrate).
  static List<SlotDef> slots = buildDefaults();

  static SlotDef? find(String id) {
    for (final s in slots) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Gọi khi kéo thả xong 1 slot trong debug mode.
  static void updateSlotCenter(String id, Vector2 center) {
    final def = find(id);
    if (def != null) def.center = center;
  }

  static void loadFromJsonString(String src) {
    final list = (jsonDecode(src) as List).cast<Map<String, dynamic>>();
    slots = list.map(SlotDef.fromJson).toList();
  }

  static String exportJson() => const JsonEncoder.withIndent(
    '  ',
  ).convert(slots.map((s) => s.toJson()).toList());
}
```

### `D:\personal\cat_defense/lib\game_data.dart`
```dart
// lib/game_data.dart

// ============================================================================
// 1. DỮ LIỆU MÈO (CAT LEVEL DATA)
// ============================================================================
class CatLevelData {
  final int level;
  final int cost;
  final double damage;
  final double range;
  final double attackInterval; // Khoảng thời gian giữa 2 lần bắn (giây)
  final String atlasPath;
  final String jsonPath;
  final String animationName;
  
  // Các thuộc tính căn chỉnh vị trí & đạn
  final double visualOffsetX;
  final double visualOffsetY;
  final double muzzleX;
  final double muzzleY;
  final String bulletSpritePath;

  const CatLevelData({
    required this.level,
    required this.cost,
    required this.damage,
    required this.range,
    required this.attackInterval,
    required this.atlasPath,
    required this.jsonPath,
    this.animationName = 'idle',
    this.visualOffsetX = 0.0,
    this.visualOffsetY = 0.0,
    this.muzzleX = 0.0,
    this.muzzleY = 0.0,
    this.bulletSpritePath = '',
  });

  // --- Getters tương thích với code cũ ---
  int get upgradeCost => cost;
  double get fireRate => attackInterval;
  String get bulletSprite => bulletSpritePath.isNotEmpty 
      ? bulletSpritePath 
      : 'assets/Png/Bullets/Artboard_1.png';
}

/// Danh sách 15 cấp độ Mèo
final List<CatLevelData> catLevels = List.generate(15, (i) {
  final lv = i + 1;
  return CatLevelData(
    level: lv,
    cost: 50 + (i * 35),
    damage: 12.0 + (i * 8.5),
    range: 130.0 + (i * 6.0),
    attackInterval: (1.2 - (i * 0.04)).clamp(0.4, 1.2),
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat$lv/Character$lv.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat$lv/Character$lv.json',
    visualOffsetX: 0.0,
    visualOffsetY: -10.0,
    muzzleX: 15.0,
    muzzleY: -20.0,
    bulletSpritePath: 'assets/Png/Bullets/Artboard_1.png',
  );
});

// Helper lấy data mèo theo level
CatLevelData getCatDataByLevel(int level) {
  final index = (level - 1).clamp(0, catLevels.length - 1);
  return catLevels[index];
}

// ============================================================================
// 2. DỮ LIỆU QUÁI VẬT (ENEMY DATA)
// ============================================================================
class EnemyTypeData {
  final String id;
  final String name;
  final double maxHp;
  final double speed;
  final int coinReward;
  final bool isBoss;
  final String atlasPath;
  final String jsonPath;
  final double scale;

  const EnemyTypeData({
    required this.id,
    required this.name,
    required this.maxHp,
    required this.speed,
    required this.coinReward,
    this.isBoss = false,
    required this.atlasPath,
    required this.jsonPath,
    this.scale = 1.0,
  });

  // --- Getters tương thích với code cũ ---
  double get hp => maxHp;
  int get reward => coinReward;
}

/// Danh sách Quái: 8 Quái thường + 7 Boss
final List<EnemyTypeData> enemyRegistry = [
  // --- 8 QUÁI THƯỜNG ---
  ...List.generate(8, (i) {
    final idx = i + 1;
    return EnemyTypeData(
      id: 'reg_$idx',
      name: 'Regular Enemy $idx',
      maxHp: 40.0 + (i * 30.0),
      speed: 45.0 + (i * 4.0),
      coinReward: 10 + (i * 4),
      isBoss: false,
      atlasPath: 'assets/Json_Atlas/Enemies/Enemy_Reg_$idx/Enemy.atlas',
      jsonPath: 'assets/Json_Atlas/Enemies/Enemy_Reg_$idx/Enemy.json',
      scale: 0.85,
    );
  }),

  // --- 7 BOSS ---
  ...List.generate(7, (i) {
    final idx = i + 1;
    return EnemyTypeData(
      id: 'boss_$idx',
      name: 'Boss Enemy $idx',
      maxHp: 350.0 + (i * 220.0),
      speed: 32.0 + (i * 3.0),
      coinReward: 120 + (i * 60),
      isBoss: true,
      atlasPath: 'assets/Json_Atlas/Enemies/Enemy_Boss_$idx/Enemy.atlas',
      jsonPath: 'assets/Json_Atlas/Enemies/Enemy_Boss_$idx/Enemy.json',
      scale: 1.25,
    );
  }),
];

// Helper tìm quái theo ID
EnemyTypeData getEnemyById(String id) {
  return enemyRegistry.firstWhere(
    (e) => e.id == id,
    orElse: () => enemyRegistry.first,
  );
}

// ============================================================================
// 3. DỮ LIỆU KỸ NĂNG / ADDON (SKILL DATA)
// ============================================================================
class SkillData {
  final String id;
  final String name;
  final String iconPath;
  final int cost;
  final double cooldown;
  final double damage;
  final double radius;

  const SkillData({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.cost,
    required this.cooldown,
    required this.damage,
    required this.radius,
  });
}

final List<SkillData> skillRegistry = [
  const SkillData(
    id: 'spikes',
    name: 'Bẫy Gai',
    iconPath: 'assets/Png/Ui/AddonIcon1.png',
    cost: 30,
    cooldown: 6.0,
    damage: 40.0,
    radius: 45.0,
  ),
  const SkillData(
    id: 'tnt',
    name: 'BOM TNT',
    iconPath: 'assets/Png/Ui/AddonIcon2.png',
    cost: 80,
    cooldown: 12.0,
    damage: 180.0,
    radius: 90.0,
  ),
];

// ============================================================================
// 4. CẤU HÌNH MÀN CHƠI & WAVE (LEVEL CONFIGURATION)
// ============================================================================
class EnemySpawnInfo {
  final String enemyId;
  final int count;
  final double spawnInterval;

  const EnemySpawnInfo({
    required this.enemyId,
    required this.count,
    this.spawnInterval = 1.0,
  });
}

class WaveData {
  final int waveIndex;
  final List<EnemySpawnInfo> spawns;

  const WaveData({
    required this.waveIndex,
    required this.spawns,
  });
}

class LevelConfigData {
  final int levelNumber;
  final int initialCoins;
  final List<WaveData> waves;

  const LevelConfigData({
    required this.levelNumber,
    required this.initialCoins,
    required this.waves,
  });
}

LevelConfigData getLevelConfig(int level) {
  final regEnemyId = 'reg_${((level - 1) % 8) + 1}';
  final bossEnemyId = 'boss_${((level - 1) % 7) + 1}';

  return LevelConfigData(
    levelNumber: level,
    initialCoins: 150 + (level * 25),
    waves: [
      WaveData(
        waveIndex: 1,
        spawns: [
          EnemySpawnInfo(enemyId: regEnemyId, count: 4 + level, spawnInterval: 1.2),
        ],
      ),
      WaveData(
        waveIndex: 2,
        spawns: [
          EnemySpawnInfo(enemyId: regEnemyId, count: 6 + level, spawnInterval: 1.0),
        ],
      ),
      WaveData(
        waveIndex: 3,
        spawns: [
          EnemySpawnInfo(enemyId: regEnemyId, count: 8 + level, spawnInterval: 0.8),
          EnemySpawnInfo(enemyId: bossEnemyId, count: 1, spawnInterval: 2.0),
        ],
      ),
    ],
  );
}
```

### `D:\personal\cat_defense/lib\main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo PlayerDataManager trước khi app render
  await PlayerDataManager.instance.init();

  // 2. Cố định hướng màn hình ngang (Landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // 3. Fullscreen Sticky Immersive
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Defense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const LandingScreen(), // Đặt LandingScreen làm trang chủ
    );
  }
}
```

### `D:\personal\cat_defense/lib\managers\player_data_manager.dart`
```dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cat_defense/models/player_data.dart';

class PlayerDataManager extends ChangeNotifier {
  static final PlayerDataManager instance = PlayerDataManager._internal();
  PlayerDataManager._internal();

  static const String _storageKey = 'CAT_DEFENSE_PLAYER_DATA_V1';
  late PlayerData _data;

  PlayerData get data => _data;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString(_storageKey);

    if (rawData != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(rawData);
        final catsMap = (json['cats'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, CatData.fromJson(v)),
        );

        _data = PlayerData(
          coins: json['coins'] ?? 1000,
          gems: json['gems'] ?? 10,
          unlockedLevel: json['unlockedLevel'] ?? 1,
          cats: catsMap,
          selectedCats: List<String>.from(json['selectedCats'] ?? ['Cat1']),
        );
        return;
      } catch (e) {
        debugPrint('Error parsing PlayerData: $e');
      }
    }

    // Default Fallback
    final defaultCats = <String, CatData>{};
    for (int i = 1; i <= 15; i++) {
      final id = 'Cat$i';
      defaultCats[id] = CatData(id: id, isUnlocked: i == 1);
    }

    _data = PlayerData(cats: defaultCats, selectedCats: ['Cat1']);
    await saveData();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMap = {
      'coins': _data.coins,
      'gems': _data.gems,
      'unlockedLevel': _data.unlockedLevel,
      'selectedCats': _data.selectedCats,
      'cats': _data.cats.map((k, v) => MapEntry(k, v.toJson())),
    };
    await prefs.setString(_storageKey, jsonEncode(jsonMap));
    notifyListeners(); // Thông báo cho UI đăng ký Listenable
  }

  Future<void> addCoins(int amount) async {
    _data.coins += amount;
    await saveData();
  }

  Future<bool> spendCoins(int amount) async {
    if (_data.coins >= amount) {
      _data.coins -= amount;
      await saveData();
      return true;
    }
    return false;
  }

  Future<void> completeLevel(int completedLevel) async {
    if (completedLevel == _data.unlockedLevel && _data.unlockedLevel < 15) {
      _data.unlockedLevel++;
      await saveData();
    }
  }

  Future<bool> unlockCat(String catId) async {
    if (_data.cats.containsKey(catId) && !_data.cats[catId]!.isUnlocked) {
      _data.cats[catId]!.isUnlocked = true;
      await saveData();
      return true;
    }
    return false;
  }

  Future<void> updateSelectedCats(List<String> catIds) async {
    _data.selectedCats = catIds;
    await saveData();
  }

  Future<bool> unlockCatWithCoins(String catId, int price) async {
    final cat = _data.cats[catId];
    if (cat != null && !cat.isUnlocked && _data.coins >= price) {
      _data.coins -= price;
      cat.isUnlocked = true;
      await saveData();
      return true; // Mua thành công
    }
    return false; // Mua thất bại (không đủ tiền hoặc đã mở)
  }

  Future<bool> upgradeCatWithCoins(String catId, int price) async {
    final cat = _data.cats[catId];
    if (cat != null && cat.isUnlocked && _data.coins >= price) {
      _data.coins -= price;
      cat.level += 1;
      await saveData();
      return true; // Nâng cấp thành công
    }
    return false; // Nâng cấp thất bại
  }
}
```

### `D:\personal\cat_defense/lib\models\player_data.dart`
```dart
class CatData {
  final String id;
  int level;
  bool isUnlocked;

  CatData({required this.id, this.level = 1, this.isUnlocked = false});

  Map<String, dynamic> toJson() => {
    'id': id,
    'level': level,
    'isUnlocked': isUnlocked,
  };

  factory CatData.fromJson(Map<String, dynamic> json) => CatData(
    id: json['id'],
    level: json['level'] ?? 1,
    isUnlocked: json['isUnlocked'] ?? false,
  );
}

class PlayerData {
  int coins;
  int gems;
  int unlockedLevel;
  Map<String, CatData> cats;
  List<String> selectedCats;

  PlayerData({
    this.coins = 1000,
    this.gems = 10,
    this.unlockedLevel = 1,
    required this.cats,
    required this.selectedCats,
  });
}
```

### `D:\personal\cat_defense/lib\screens\game_screen.dart`
```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/ui/game_ui.dart';
import 'package:cat_defense/ui/pause_dialog.dart';
import 'package:cat_defense/ui/win_dialog.dart';
import 'package:cat_defense/ui/lose_dialog.dart';

class GameScreen extends StatefulWidget {
  final int level;
  const GameScreen({super.key, this.level = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late CatDefenseGame _game;

  @override
  void initState() {
    super.initState();
    _game = CatDefenseGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<CatDefenseGame>(
        game: _game,
        overlayBuilderMap: {
          'GameUI': (context, game) => GameUI(game: game),
          'Pause': (context, game) => PauseDialog(
                onResume: () {
                  game.overlays.remove('Pause');
                  game.resumeEngine();
                },
                onRestart: () {
                  game.reset();
                },
                onQuit: () => Navigator.pop(context),
              ),
          'WinScreen': (context, game) => WinDialog(
                level: widget.level,
                coinsEarned: widget.level * 200,
                onNextLevel: () => Navigator.pop(context),
                onRestart: () => game.reset(),
                onQuit: () => Navigator.pop(context),
              ),
          'GameOver': (context, game) => LoseDialog(
                onRestart: () => game.reset(),
                onQuit: () => Navigator.pop(context),
              ),
        },
        initialActiveOverlays: const ['GameUI'],
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\screens\landing_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/ui/settings_dialog.dart';
import 'package:cat_defense/ui/daily_reward_dialog.dart';
import 'package:cat_defense/screens/game_screen.dart';
import 'package:cat_defense/screens/level_map_screen.dart';
import 'package:cat_defense/screens/shop_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/Png/Ui/LandingScreen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Currency Top Bar (Rebuild tự động khi PlayerDataManager thay đổi)
          Positioned(
            top: 24,
            left: 20,
            right: 20,
            child: ListenableBuilder(
              listenable: playerManager,
              builder: (context, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCurrencyChip(
                      'assets/Png/Ui/CoinBar.png',
                      '${playerManager.data.coins}',
                    ),
                    _buildCurrencyChip(
                      'assets/Png/Ui/GemsBarBg.png',
                      '${playerManager.data.gems}',
                    ),
                  ],
                );
              },
            ),
          ),

          // Main Action Buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Button Play Game
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LevelMapScreen(),
                      ), // Chuyển tới LevelMapScreen
                    );
                  },
                  child: Image.asset('assets/Png/Ui/BtnOrange.png', width: 180),
                ),
                const SizedBox(height: 20),
                // Dialog Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/Png/Ui/DaillyIcon.png',
                        width: 60,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const DailyRewardDialog(),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Image.asset(
                        'assets/Png/Ui/SettingBtn.png',
                        width: 60,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const SettingsDialog(),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.amber,
                        size: 42,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ShopScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyChip(String assetPath, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(180),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Row(
        children: [
          Image.asset(assetPath, width: 26, height: 26),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\screens\level_map_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/screens/game_screen.dart';

class LevelMapScreen extends StatelessWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;

    return Scaffold(
      body: Stack(
        children: [
          // Background Map
          Positioned.fill(
            child: Image.asset(
              'assets/Png/Ui/LandingScreen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Nút Quay lại (Back Button)
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Tiêu đề
          const Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'CHỌN MÀN CHƠI',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Danh sách 15 Mốc Level (Grid 5x3 tối ưu cho Landscape)
          Positioned.fill(
            top: 70,
            child: ListenableBuilder(
              listenable: playerManager,
              builder: (context, _) {
                final unlockedLevel = playerManager.data.unlockedLevel;

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    final level = index + 1;
                    final isUnlocked = level <= unlockedLevel;

                    return _buildLevelItem(
                      context: context,
                      level: level,
                      isUnlocked: isUnlocked,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelItem({
    required BuildContext context,
    required int level,
    required bool isUnlocked,
  }) {
    return GestureDetector(
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GameScreen(level: level)),
              );
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Render logo Uplogo1 đến Uplogo15
          ColorFiltered(
            colorFilter: isUnlocked
                ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
            child: Image.asset(
              'assets/Png/Ui/Uplogo$level.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback UI nếu không tìm thấy file ảnh Uplogo tương ứng
                return Container(
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? Colors.amber.shade600
                        : Colors.grey.shade700,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Tấm phủ khóa (Lock Overlay) nếu chưa được Unlocked
          if (!isUnlocked)
            Container(
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.lock, color: Colors.white70, size: 26),
            ),
        ],
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\screens\shop_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/models/player_data.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E24),
      body: SafeArea(
        child: Stack(
          children: [
            // Top Bar: Back Button & Currencies
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'CỬA HÀNG MÈO',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListenableBuilder(
                    listenable: playerManager,
                    builder: (context, _) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.shade600),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/Png/Ui/CoinBar.png',
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${playerManager.data.coins}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Grid View 15 Cats
            Positioned.fill(
              top: 70,
              child: ListenableBuilder(
                listenable: playerManager,
                builder: (context, _) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, // 5 cột phù hợp màn hình Landscape
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      final catId = 'Cat${index + 1}';
                      final catData =
                          playerManager.data.cats[catId] ?? CatData(id: catId);
                      final unlockPrice =
                          (index + 1) * 300; // Giá unlock tăng dần
                      final upgradePrice =
                          catData.level * 150; // Giá nâng cấp theo level

                      return _buildCatCard(
                        context: context,
                        catId: catId,
                        catData: catData,
                        unlockPrice: unlockPrice,
                        upgradePrice: upgradePrice,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatCard({
    required BuildContext context,
    required String catId,
    required CatData catData,
    required int unlockPrice,
    required int upgradePrice,
  }) {
    final playerManager = PlayerDataManager.instance;
    final int baseDamage = 20;
    final int currentDamage = baseDamage + (catData.level - 1) * 10;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C34),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: catData.isUnlocked
              ? Colors.amber.shade600
              : Colors.grey.shade700,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tên & Level
          Text(
            catData.isUnlocked ? '$catId (Lv.${catData.level})' : catId,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          // Ảnh Đại diện Mèo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image.asset(
                'assets/Png/Ui/Uplogo${catId.replaceAll('Cat', '')}.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.pets, size: 40, color: Colors.amber),
              ),
            ),
          ),

          // Chỉ số ATK
          Text(
            'ATK: $currentDamage',
            style: const TextStyle(
              color: Colors.lightGreenAccent,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          // Nút Mua / Nâng cấp
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: catData.isUnlocked
                    ? Colors.orange.shade700
                    : Colors.green.shade700,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if (!catData.isUnlocked) {
                  // Mua Mèo
                  final success = await playerManager.unlockCatWithCoins(
                    catId,
                    unlockPrice,
                  );
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không đủ Coin để mở khóa Mèo!'),
                      ),
                    );
                  }
                } else {
                  // Nâng cấp Mèo
                  final success = await playerManager.upgradeCatWithCoins(
                    catId,
                    upgradePrice,
                  );
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không đủ Coin để nâng cấp!'),
                      ),
                    );
                  }
                }
              },
              child: Text(
                catData.isUnlocked
                    ? 'Lv+1 ($upgradePrice)'
                    : 'Mở ($unlockPrice)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\ui\daily_reward_dialog.dart`
```dart
import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';

class DailyRewardDialog extends StatelessWidget {
  const DailyRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.amber, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 15, spreadRadius: 3),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "ĐIỂM DANH HÀNG NGÀY",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset('assets/Png/Ui/CoinIcon.png', width: 64, height: 64),
            const SizedBox(height: 12),
            const Text(
              "Nhận ngay 500 Coins!",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                await PlayerDataManager.instance.addCoins(500);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text(
                "NHẬN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\ui\game_ui.dart`
```dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/components/castle_component.dart';
import 'package:cat_defense/components/placement_slot.dart';
import 'package:cat_defense/game_data.dart';

class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / CatDefenseGame.logicalSize.x;
        final scaleY = constraints.maxHeight / CatDefenseGame.logicalSize.y;
        final double scale = min(scaleX, scaleY);

        return SafeArea(
          child: Stack(
            children: [
              // Top-left: Coins & Castle HP
              Positioned(
                top: 12 * scale,
                left: 16 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _coinBar(scale),
                    SizedBox(height: 8 * scale),
                    _castleHpBar(scale),
                  ],
                ),
              ),

              // Top-right: Wave & Pause
              Positioned(
                top: 12 * scale,
                right: 16 * scale,
                child: Row(
                  children: [
                    _waveBar(scale),
                    SizedBox(width: 10 * scale),
                    _iconButton(
                      scale,
                      icon: Icons.pause_rounded,
                      onTap: () {
                        game.pauseEngine();
                        game.overlays.add('Pause');
                      },
                    ),
                  ],
                ),
              ),

              // Bottom HUD Bar (Shop Deck + Skills)
              Positioned(
                bottom: 12 * scale,
                left: 16 * scale,
                right: 16 * scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _shopBar(scale)),
                    SizedBox(width: 16 * scale),
                    Row(
                      children: [
                        _skillButton(
                          scale,
                          skillKey: 'spikes',
                          iconPath: 'assets/Png/Ui/AddonIcon1.png',
                          cost: CatDefenseGame.skillCosts['spikes']!,
                        ),
                        SizedBox(width: 8 * scale),
                        _skillButton(
                          scale,
                          skillKey: 'tnt',
                          iconPath: 'assets/Png/Ui/AddonIcon2.png',
                          cost: CatDefenseGame.skillCosts['tnt']!,
                        ),
                        SizedBox(width: 8 * scale),
                        _repairButton(scale),
                      ],
                    ),
                  ],
                ),
              ),

              _cancelSelection(scale),
              _catActionMenu(scale),
              _toast(scale),
            ],
          ),
        );
      },
    );
  }

  Widget _coinBar(double scale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 6 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(200),
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(
          color: Colors.amber.withAlpha(180),
          width: 2 * scale,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/Png/Ui/CoinIcon.png', width: 26 * scale),
          SizedBox(width: 8 * scale),
          ValueListenableBuilder<int>(
            valueListenable: game.coins,
            builder: (context, value, _) => Text(
              '$value',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 20 * scale,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _castleHpBar(double scale) {
    return ValueListenableBuilder<double>(
      valueListenable: game.castleHp,
      builder: (context, hp, _) => Container(
        width: 180 * scale,
        height: 16 * scale,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          borderRadius: BorderRadius.circular(10 * scale),
          border: Border.all(color: Colors.white24, width: 1.5 * scale),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: hp.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: hp > 0.3 ? Colors.greenAccent : Colors.redAccent,
              borderRadius: BorderRadius.circular(8 * scale),
            ),
          ),
        ),
      ),
    );
  }

  Widget _waveBar(double scale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 8 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(200),
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(color: Colors.white24, width: 1.5 * scale),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: game.currentWave,
        builder: (context, wave, _) => Text(
          'WAVE ${min(wave, CatDefenseGame.totalWaves)} / ${CatDefenseGame.totalWaves}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16 * scale,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _iconButton(
    double scale, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42 * scale,
        height: 42 * scale,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(color: Colors.white24, width: 1.5 * scale),
        ),
        child: Icon(icon, size: 24 * scale, color: Colors.white),
      ),
    );
  }

  Widget _shopBar(double scale) {
    final cats = catLevels.take(5).toList();
    return SizedBox(
      height: 95 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (context, index) => SizedBox(width: 8 * scale),
        itemBuilder: (context, i) => _catCard(scale, cats[i]),
      ),
    );
  }

  Widget _catCard(double scale, CatLevelData data) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (context, selected, _) {
        final isSelected = selected?.level == data.level;
        return ValueListenableBuilder<int>(
          valueListenable: game.coins,
          builder: (context, coins, _) {
            final afford = coins >= data.cost;
            return GestureDetector(
              onTap: () {
                if (!afford && !isSelected) {
                  game.showToast('Not enough coins!');
                  return;
                }
                game.selectedCatData.value = isSelected ? null : data;
                game.selectedSkill.value = null;
              },
              child: Opacity(
                opacity: afford ? 1.0 : 0.5,
                child: Container(
                  width: 75 * scale,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.amber.shade700
                        : const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12 * scale),
                    border: Border.all(
                      color: isSelected ? Colors.amberAccent : Colors.white24,
                      width: isSelected ? 2.5 * scale : 1.5 * scale,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 26 * scale,
                        color: isSelected ? Colors.white : Colors.amber,
                      ),
                      SizedBox(height: 2 * scale),
                      Text(
                        'Lv ${data.level}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13 * scale,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${data.cost}',
                        style: TextStyle(
                          fontSize: 12 * scale,
                          fontWeight: FontWeight.w600,
                          color: afford ? Colors.amberAccent : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _skillButton(
    double scale, {
    required String skillKey,
    required String iconPath,
    required int cost,
  }) {
    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: game.skillCounts,
      builder: (context, counts, _) {
        final left = counts[skillKey] ?? 0;
        return ValueListenableBuilder<String?>(
          valueListenable: game.selectedSkill,
          builder: (context, sel, _) {
            final isSel = sel == skillKey;
            return ValueListenableBuilder<int>(
              valueListenable: game.coins,
              builder: (context, coins, _) {
                final usable = left > 0 && coins >= cost;
                return GestureDetector(
                  onTap: () {
                    if (left <= 0) {
                      game.showToast('Out of uses!');
                      return;
                    }
                    if (coins < cost) {
                      game.showToast('Not enough coins!');
                      return;
                    }
                    game.selectedSkill.value = isSel ? null : skillKey;
                    game.selectedCatData.value = null;
                  },
                  child: Opacity(
                    opacity: usable ? 1 : 0.45,
                    child: Container(
                      width: 75 * scale,
                      height: 95 * scale,
                      decoration: BoxDecoration(
                        color: isSel
                            ? Colors.redAccent.shade400
                            : const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12 * scale),
                        border: Border.all(
                          color: isSel ? Colors.white : Colors.white24,
                          width: 2 * scale,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(iconPath, width: 38 * scale),
                          ),
                          Positioned(
                            right: 6 * scale,
                            top: 4 * scale,
                            child: Text(
                              'x$left',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11 * scale,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 4 * scale,
                            child: Text(
                              '$cost',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12 * scale,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _repairButton(double scale) {
    return ValueListenableBuilder<double>(
      valueListenable: game.castleHp,
      builder: (context, hp, _) {
        return ValueListenableBuilder<int>(
          valueListenable: game.coins,
          builder: (context, coins, _) {
            final cost = CastleComponent.repairCost;
            final usable = hp < 1.0 && coins >= cost;
            return GestureDetector(
              onTap: usable ? game.castle.repair : null,
              child: Opacity(
                opacity: usable ? 1 : 0.45,
                child: Container(
                  width: 75 * scale,
                  height: 95 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12 * scale),
                    border: Border.all(
                      color: Colors.white24,
                      width: 1.5 * scale,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.build_rounded,
                        size: 26 * scale,
                        color: Colors.greenAccent,
                      ),
                      SizedBox(height: 2 * scale),
                      Text(
                        'Repair',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12 * scale,
                        ),
                      ),
                      Text(
                        '${cost.toInt()}',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 11 * scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _cancelSelection(double scale) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (context, cat, _) => ValueListenableBuilder<String?>(
        valueListenable: game.selectedSkill,
        builder: (context, skill, _) {
          final visible = cat != null || skill != null;
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: visible ? 70 * scale : -80 * scale,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  game.selectedCatData.value = null;
                  game.selectedSkill.value = null;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18 * scale,
                    vertical: 6 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16 * scale),
                  ),
                  child: Text(
                    'Cancel Selection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13 * scale,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _catActionMenu(double scale) {
    return ValueListenableBuilder<PlacementSlot?>(
      valueListenable: game.selectedSlot,
      builder: (context, slot, _) {
        final cat = slot?.residentCat;
        if (slot == null || cat == null) return const SizedBox.shrink();
        return Positioned(
          top: 150 * scale,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 6 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(220),
                borderRadius: BorderRadius.circular(14 * scale),
                border: Border.all(color: Colors.white24, width: 1.5 * scale),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionButton(
                    scale,
                    label: 'Upgrade (${cat.data.upgradeCost})',
                    icon: Icons.arrow_upward,
                    color: Colors.greenAccent,
                    onTap: slot.upgradeCat,
                  ),
                  SizedBox(width: 8 * scale),
                  _actionButton(
                    scale,
                    label: 'Sell (${(cat.data.cost * 0.5).round()})',
                    icon: Icons.sell,
                    color: Colors.orangeAccent,
                    onTap: slot.sellCat,
                  ),
                  SizedBox(width: 8 * scale),
                  _actionButton(
                    scale,
                    label: 'Close',
                    icon: Icons.close,
                    color: Colors.white70,
                    onTap: () => game.selectedSlot.value = null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(
    double scale, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10 * scale,
          vertical: 5 * scale,
        ),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8 * scale),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16 * scale),
            SizedBox(width: 4 * scale),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toast(double scale) {
    return ValueListenableBuilder<String?>(
      valueListenable: game.toast,
      builder: (context, msg, _) => AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: msg == null ? 0 : 1,
        child: IgnorePointer(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 80 * scale),
              padding: EdgeInsets.symmetric(
                horizontal: 20 * scale,
                vertical: 8 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(220),
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              child: Text(
                msg ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\ui\lose_dialog.dart`
```dart
import 'package:flutter/material.dart';

class LoseDialog extends StatelessWidget {
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const LoseDialog({super.key, required this.onRestart, required this.onQuit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "THẤT BẠI!",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Thành lũy đã bị phá hủy!",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: onRestart,
              child: const Center(
                child: Text(
                  "CHƠI LẠI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: onQuit,
              child: const Center(child: Text("THOÁT RA MAP")),
            ),
          ],
        ),
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\ui\pause_dialog.dart`
```dart
import 'package:flutter/material.dart';

class PauseDialog extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const PauseDialog({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "TẠM DỪNG",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: onResume,
              child: const Center(
                child: Text(
                  "TIẾP TỤC",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: onRestart,
              child: const Center(
                child: Text(
                  "CHƠI LẠI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: onQuit,
              child: const Center(child: Text("THOÁT RA MAP")),
            ),
          ],
        ),
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\ui\settings_dialog.dart`
```dart
import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool isSoundOn = true;
  bool isMusicOn = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "CÀI ĐẶT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset(
                    isSoundOn
                        ? 'assets/Png/Ui/BtnSound.png'
                        : 'assets/Png/Ui/BtnMusic.png',
                    width: 54,
                  ),
                  onPressed: () => setState(() => isSoundOn = !isSoundOn),
                ),
                IconButton(
                  icon: Image.asset(
                    isMusicOn
                        ? 'assets/Png/Ui/BtnMusic.png'
                        : 'assets/Png/Ui/BtnSound.png',
                    width: 54,
                  ),
                  onPressed: () => setState(() => isMusicOn = !isMusicOn),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### `D:\personal\cat_defense/lib\ui\win_dialog.dart`
```dart
import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';

class WinDialog extends StatefulWidget {
  final int level;
  final int coinsEarned;
  final VoidCallback onNextLevel;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const WinDialog({
    super.key,
    required this.level,
    required this.coinsEarned,
    required this.onNextLevel,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog> {
  @override
  void initState() {
    super.initState();
    _rewardPlayer();
  }

  Future<void> _rewardPlayer() async {
    final manager = PlayerDataManager.instance;
    await manager.completeLevel(widget.level);
    await manager.addCoins(widget.coinsEarned);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "CHIẾN THẮNG!",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Png/Ui/CoinBar.png', width: 28),
                const SizedBox(width: 8),
                Text(
                  "+${widget.coinsEarned}",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.level < 15)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget.onNextLevel,
                child: const Center(
                  child: Text(
                    "MÀN TIẾP THEO",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: widget.onRestart,
              child: const Center(
                child: Text(
                  "CHƠI LẠI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: widget.onQuit,
              child: const Center(child: Text("THOÁT RA MAP")),
            ),
          ],
        ),
      ),
    );
  }
}
```

