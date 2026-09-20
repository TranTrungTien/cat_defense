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
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/managers/run_manager.dart';
import 'package:cat_defense/managers/ai_director.dart';

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

  // Team Energy System
  final ValueNotifier<double> teamEnergy = ValueNotifier(0.0);
  final ValueNotifier<double> teamUltimate = ValueNotifier(0.0);
  static const double maxTeamEnergy = 100.0;
  static const double energyRegenPerSecond = 1.0;

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

  PlacementSlot? draggingCatSlot;
  PlacementSlot? hoveredSlot;

  late final AIDirector aiDirector;

  final Map<String, List<Sprite>> fxCache = {};
  final Map<int, (AtlasFlutter, SkeletonData)> catSpinePool = {};
  final Map<String, (AtlasFlutter, SkeletonData)> enemySpinePool = {};

  async.Timer? _toastTimer;
  TimerComponent? _waveTimer;
  double _shakeTimer = 0;
  double _shakeIntensity = 0;
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
    aiDirector = AIDirector(this);
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
  void update(double dt) {
    super.update(dt);
    if (!isGameOver.value) {
      _updateEnergy(dt);
      aiDirector.update(dt);
      _updateShake(dt);
    }
  }

  void _updateShake(double dt) {
    if (_shakeTimer > 0) {
      _shakeTimer -= dt;
      final random = Random();
      camera.viewfinder.position = (logicalSize / 2) + Vector2(
        (random.nextDouble() - 0.5) * 2 * _shakeIntensity,
        (random.nextDouble() - 0.5) * 2 * _shakeIntensity,
      );
      if (_shakeTimer <= 0) {
        camera.viewfinder.position = logicalSize / 2;
      }
    }
  }

  void shakeCamera({double duration = 0.2, double intensity = 5}) {
    _shakeTimer = duration;
    _shakeIntensity = intensity;
  }

  void _updateEnergy(double dt) {
    double regen = energyRegenPerSecond;

    // Meta Upgrade: Laboratory
    final labLevel = PlayerDataManager.instance.data.baseUpgrades['laboratory'] ?? 0;
    regen += labLevel * 0.2; // 20% increase per level

    if (teamEnergy.value < maxTeamEnergy) {
      teamEnergy.value = min(maxTeamEnergy, teamEnergy.value + regen * dt);
    }

    if (teamUltimate.value >= 100.0) {
      // Logic for auto-triggering if desired, but we have a button now
    }
  }

  void triggerTeamUltimate() {
    if (teamUltimate.value < 100.0) return;
    teamUltimate.value = 0.0;
    showToast('TEAM ULTIMATE: AIR STRIKE!');
    shakeCamera(duration: 0.8, intensity: 15);

    // Damage all enemies
    final enemies = List<EnemyComponent>.of(cachedEnemies);
    for (final enemy in enemies) {
      enemy.takeDamage(100);
      enemy.applyStatusEffect('slow', 3.0);
    }
  }

  void gainEnergy(double amount) {
    teamEnergy.value = min(maxTeamEnergy, teamEnergy.value + amount);
  }

  bool consumeEnergy(double amount) {
    // Meta Upgrade: Workshop
    final workshopLevel = PlayerDataManager.instance.data.baseUpgrades['workshop'] ?? 0;
    final discountedAmount = amount * (1.0 - (workshopLevel * 0.05)).clamp(0.5, 1.0); // 5% reduction per level

    if (teamEnergy.value >= discountedAmount) {
      teamEnergy.value -= discountedAmount;
      return true;
    }
    return false;
  }

  void gainUltimate(double amount) {
    teamUltimate.value = min(100.0, teamUltimate.value + amount);
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

    // PRD 20: Threat Modifiers
    if (waveNumber % 10 == 0 && waveNumber > 0) {
      _applyThreatModifier();
    }

    final spawns = aiDirector.generateWave(waveNumber);

    if (waveNumber % 5 == 0) {
      showToast('BOSS INCOMING!');
    }

    _spawnSequence(spawns, waveNumber);
  }

  void _applyThreatModifier() {
    final modifiers = ['armored_outbreak', 'night_invasion', 'toxic_streets', 'elite_territory'];
    final mod = modifiers[Random().nextInt(modifiers.length)];
    RunManager.instance.activeModifiers.add(mod);
    showToast('THREAT MODIFIER: ${mod.toUpperCase()}');
  }

  void _spawnSequence(List<EnemySpawnInfo> spawns, int waveNumber) {
    int currentSpawnIdx = 0;
    int currentCount = 0;

    void spawnNext() {
      if (isGameOver.value || !isMounted) return;
      if (currentSpawnIdx >= spawns.length) return;

      final spawnInfo = spawns[currentSpawnIdx];
      final enemyData = getEnemyById(spawnInfo.enemyId);

      _pendingSpawnCount++;
      add(EnemyComponent(data: enemyData));
      currentCount++;

      if (currentCount >= spawnInfo.count) {
        currentSpawnIdx++;
        currentCount = 0;
      }

      if (currentSpawnIdx < spawns.length) {
        add(TimerComponent(
          period: spawns[currentSpawnIdx].spawnInterval,
          onTick: spawnNext,
        ));
      }
    }

    spawnNext();
  }

  void checkWinCondition() {
    if (isGameOver.value || currentWave.value < totalWaves) return;
    if (_pendingSpawnCount <= 0 &&
        world.children.whereType<EnemyComponent>().isEmpty) {
      isGameOver.value = true;

      PlayerDataManager.instance.recordRun(
        currentWave.value,
        1,
        RunManager.instance.activePerks.toList(),
      );

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

    PlayerDataManager.instance.recordRun(
      currentWave.value,
      1, // Biome placeholder
      RunManager.instance.activePerks.toList(),
    );

    pauseEngine();
    overlays.add('GameOver');
  }

  void registerEnemy(EnemyComponent enemy) {
    if (!_cachedEnemies.contains(enemy)) _cachedEnemies.add(enemy);
  }

  void onEnemyRemove(EnemyComponent enemy) {
    _cachedEnemies.remove(enemy);
    _pendingSpawnCount--;
    checkWinCondition();

    // If wave is cleared, move to next
    if (_pendingSpawnCount <= 0 && !isGameOver.value) {
      final finishedWave = currentWave.value;

      // Perk: Emergency Repair
      if (RunManager.instance.activePerks.contains('emergency_repair')) {
        castle.repair(amount: castle.maxHp * 0.05, free: true);
      }

      // Roguelite: Offer perks every 3 waves
      if (finishedWave % 3 == 0) {
         pauseEngine();
         overlays.add('PerkSelector');
      }

      final nextWave = currentWave.value + 1;
      if (nextWave <= totalWaves) {
        currentWave.value = nextWave;
        _startWaveManager();
      } else {
        checkWinCondition();
      }
    }
  }

  void reset() {
    _pendingSpawnCount = 0;
    _waveTimer?.removeFromParent();
    _waveTimer = null;
    score.value = 0;

    // Meta Upgrade: Armory
    final armoryLevel = PlayerDataManager.instance.data.baseUpgrades['armory'] ?? 0;
    coins.value = initialCoins + (armoryLevel * 500);

    castleHp.value = 1.0;
    teamEnergy.value = 0.0;
    teamUltimate.value = 0.0;
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
