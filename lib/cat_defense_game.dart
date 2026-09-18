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

  static const int skillMaxCharges = 5;
  static const Map<String, int> skillCosts = {
    'spikes': 200,
    'tnt': 500,
    'boxer': 300,
  };

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
    'boxer': 2,
  });
  final ValueNotifier<String?> toast = ValueNotifier(null);
  final ValueNotifier<int> spawnLevel = ValueNotifier(1);

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
    camera = CameraComponent();

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
    if (skill == 'boxer') add(TntComponent(position: localPos));
    selectedSkill.value = null;
  }

  void showToast(String message) {
    toast.value = message;
    _toastTimer?.cancel();
    _toastTimer = async.Timer(const Duration(milliseconds: 1500), () {
      toast.value = null;
    });
  }

  void spawnFromHud() {
    final data = getCatDataByLevel(spawnLevel.value);
    if (coins.value < data.cost) {
      showToast('Not enough coins!');
      return;
    }
    PlacementSlot? empty;
    for (final s in world.children.whereType<PlacementSlot>()) {
      if (!s.isOccupied && !s.isWallSlot && !s.isDeleteSlot) {
        empty = s;
        break;
      }
    }
    if (empty == null) {
      showToast('No space!');
      return;
    }
    coins.value -= data.cost;
    empty.placeFromHud(data);
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
    spawnLevel.value = 1;
    skillCounts.value = {'spikes': 2, 'tnt': 3, 'boxer': 2};
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
