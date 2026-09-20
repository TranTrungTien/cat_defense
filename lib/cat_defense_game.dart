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
import 'package:cat_defense/components/cat_component.dart';
import 'package:cat_defense/managers/ai_director.dart';
import 'package:cat_defense/managers/run_manager.dart';

class CatDefenseGame extends FlameGame
    with HasCollisionDetection, TapCallbacks {
  static final Vector2 logicalSize = Vector2(1920, 1080);
  static const int totalWaves = 999;
  static const int initialCoins = 180;

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

  late final AIDirector aiDirector;
  final bool isRoguelite;
  final ValueNotifier<double> teamEnergy = ValueNotifier(50);
  int _waveAlive = 0;
  bool _waveSpawning = false;
  PlacementSlot? draggingCatSlot;

  CatDefenseGame({this.isRoguelite = true});

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
    aiDirector = AIDirector(this);
    _startWaveManager();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateCameraZoom();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver.value) return;
    aiDirector.update(dt);
    teamEnergy.value = (teamEnergy.value + dt).clamp(0, 100);
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
    if (skill == 'boxer') {
      showToast('Boxer is a cat — summon then tap it to charge');
      coins.value += cost;
      skillCounts.value = {...skillCounts.value, skill: left};
      selectedSkill.value = null;
      return;
    }
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
    final cost = summonCost(data);
    if (coins.value < cost) {
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
    coins.value -= cost;
    empty.placeFromHud(data);
  }

  void gainEnergy(num v) {
    teamEnergy.value = (teamEnergy.value + v).clamp(0, 100);
  }

  bool spendEnergy(int v) {
    if (teamEnergy.value < v) {
      showToast('Not enough Team Energy');
      return false;
    }
    teamEnergy.value -= v;
    return true;
  }

  int countTag(SynergyTag tag) {
    var n = 0;
    for (final s in world.children.whereType<PlacementSlot>()) {
      final c = s.residentCat;
      if (c != null && c.data.synergyTags.contains(tag)) n++;
    }
    return n;
  }

  bool hasPerk(String id) => RunManager.instance.activePerks.contains(id);

  int summonCost(CatLevelData d) {
    final base = d.cost;
    return hasPerk('summon_discount') ? (base * 0.8).round() : base;
  }

  void resumeAfterPerk() {
    overlays.remove('PerkSelector');
    resumeEngine();
    _startWaveManager();
  }

  void onEnemyRemoved() {
    _waveAlive = (_waveAlive - 1).clamp(0, 9999);
    if (!_waveSpawning && _waveAlive <= 0 && !isGameOver.value) {
      _advanceWave();
    }
  }

  void _advanceWave() {
    currentWave.value++;
    gainEnergy(8);
    if (isRoguelite && currentWave.value > 10) {
      pauseEngine();
      overlays.add('WinScreen');
      return;
    }
    if (currentWave.value % 5 == 1 && currentWave.value > 1) {
      pauseEngine();
      overlays.add('PerkSelector');
      return;
    }
    _startWaveManager();
  }

  void castCatSkill(CatComponent cat) {
    final skill = getHeroSkillById(cat.data.activeSkillId);
    if (skill == null) return;
    if (cat.cooldownLeft > 0) {
      showToast('Skill cooling down');
      return;
    }
    if (!spendEnergy(skill.energyCost)) return;

    final lane = cat.laneId;
    switch (skill.id) {
      case 'bullet_storm':
        cat.skillLock = 5;
        break;
      case 'deadeye':
        EnemyComponent? elite;
        var bestHp = -1.0;
        for (final e in cachedEnemies) {
          if (e.hp > 0 && e.laneId == lane && e.hp > bestHp) {
            bestHp = e.hp;
            elite = e;
          }
        }
        if (elite != null) {
          elite.takeDamage(cat.data.damage * 8, fromFront: true);
          if (elite.hasStatus('freeze')) {
            for (final e in cachedEnemies) {
              if (e.laneId == lane && e.hp > 0) {
                e.takeDamage(cat.data.damage * 2, fromFront: false);
              }
            }
            showToast('COMBO: Shatter Shot');
            if (hasPerk('efficient_cast')) gainEnergy(10);
            gainEnergy(10);
          }
          if (elite.hp <= 0) cat.cooldownLeft = skill.cooldown * 0.5;
        }
        break;
      case 'cluster_bomb':
      case 'turret':
        add(
          TntComponent(
            position: Vector2(
              GameLayout.castlePosition.x + 420,
              GameLayout.laneY(lane),
            ),
          ),
        );
        break;
      case 'chain_lightning':
        final sorted = cachedEnemies.where((e) => e.hp > 0).toList()
          ..sort(
            (a, b) => a.position
                .distanceTo(cat.absolutePosition)
                .compareTo(b.position.distanceTo(cat.absolutePosition)),
          );
        var hops = 0;
        for (final e in sorted.take(4)) {
          var m = cat.data.damage * 3;
          if (e.hasStatus('wet') || e.hasStatus('water')) m *= 1.6;
          e.takeDamage(m, fromFront: false);
          hops++;
        }
        if (hops >= 3) {
          showToast('COMBO: Shock Chain');
          gainEnergy(10);
        }
        break;
      case 'repair':
        castle.currentHp = (castle.currentHp + 280).clamp(0, castle.maxHp);
        castleHp.value = castle.currentHp / castle.maxHp;
        break;
      case 'absolute_zero':
        for (final e in cachedEnemies) {
          if (e.laneId == lane && e.hp > 0) {
            e.applyStatusEffect('freeze', e.data.isBoss ? 1.2 : 3.0);
            e.applyStatusEffect('slow', 4);
          }
        }
        break;
      case 'street_charge':
        for (final e in cachedEnemies) {
          if (e.laneId == lane && e.hp > 0) {
            e.position.x += 140;
            e.takeDamage(cat.data.damage * 2, fromFront: false);
          }
        }
        break;
    }
    if (cat.cooldownLeft <= 0) cat.cooldownLeft = skill.cooldown;
    showToast(skill.name);
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
    _waveTimer?.removeFromParent();
    final timer = TimerComponent(
      period: _getWavePeriod(currentWave.value),
      removeOnFinish: true,
      onTick: () {
        _waveTimer = null;
        if (!isGameOver.value) _spawnWave();
      },
    );
    _waveTimer = timer;
    add(timer);
  }

  double _getWavePeriod(int wave) => (8.0 - wave * 0.3).clamp(4.0, 8.0);

  void _spawnWave() {
    _waveSpawning = true;
    _waveAlive = 0;

    final spawns = aiDirector.generateWave(currentWave.value);
    final queue = <EnemyTypeData>[];
    for (final s in spawns) {
      final data = getEnemyById(s.enemyId);
      for (var i = 0; i < s.count; i++) {
        queue.add(data);
      }
    }
    if (queue.isEmpty) {
      _waveSpawning = false;
      _advanceWave();
      return;
    }

    _spawnOne(queue.removeAt(0));
    if (queue.isEmpty) {
      _waveSpawning = false;
      return;
    }

    late final TimerComponent t;
    t = TimerComponent(
      period: 0.7,
      repeat: true,
      onTick: () {
        if (isGameOver.value) {
          t.removeFromParent();
          return;
        }
        _spawnOne(queue.removeAt(0));
        if (queue.isEmpty) {
          t.removeFromParent();
          _waveSpawning = false;
          if (_waveAlive <= 0) _advanceWave();
        }
      },
    );
    add(t);
  }

  void _spawnOne(EnemyTypeData data) {
    _waveAlive++;
    final lane = Random().nextInt(GameLayout.laneCount);
    add(EnemyComponent(data: data, laneId: lane));
  }

  void checkWinCondition() {
    if (isRoguelite) return;
    if (isGameOver.value || currentWave.value <= 10) return;
    if (_waveAlive <= 0 && world.children.whereType<EnemyComponent>().isEmpty) {
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
        laneId: def.laneId,
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
    onEnemyRemoved();
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
    draggingCatSlot = null;
    teamEnergy.value = 50;
    _waveAlive = 0;
    _waveSpawning = false;

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
    overlays.remove('Evolution');
    overlays.remove('PerkSelector');
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
