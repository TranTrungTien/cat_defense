import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/camera.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:spine_flutter/spine_flutter.dart';
import 'components/castle_component.dart';
import 'components/enemy_component.dart';
import 'components/placement_slot.dart';
import 'components/skills/spikes_component.dart';
import 'components/skills/tnt_component.dart';
import 'game_data.dart';

class CatDefenseGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  // Reference resolution
  static final Vector2 logicalSize = Vector2(1920, 1080);

  late CastleComponent castle;
  late SpriteComponent background;
  
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> coins = ValueNotifier(5000); // Khởi đầu PvZ style
  final ValueNotifier<double> castleHp = ValueNotifier(1.0);
  final ValueNotifier<bool> isGameOver = ValueNotifier(false);
  final ValueNotifier<int> currentWave = ValueNotifier(1);
  
  // Mèo hoặc Kỹ năng đang được chọn
  final ValueNotifier<CatLevelData?> selectedCatData = ValueNotifier(null);
  final ValueNotifier<String?> selectedSkill = ValueNotifier(null);

  // Pool quản lý Spine Data để tối ưu hiệu năng
  final Map<int, (AtlasFlutter, SkeletonData)> catSpinePool = {};
  final Map<String, (AtlasFlutter, SkeletonData)> enemySpinePool = {};

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: logicalSize);
    images.prefix = '';
    await initSpineFlutter();

    // 1. Preload assets chuyên nghiệp
    await _preloadAssets();

    // 2. Load Environment
    background = SpriteComponent()
      ..sprite = await loadSprite('assets/Png/Area/Area1.png')
      ..size = logicalSize;
    add(background);

    currentWave.addListener(_onWaveChange);

    // 3. Add Castle
    castle = CastleComponent()..position = Vector2(565, 0);
    add(castle);

    // 4. Setup Placement Grid
    _setupPlacementSlots();

    // 5. Wave Spawner logic
    _startWaveManager();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    
    // Nếu đang chọn skill, đặt skill tại vị trí tap
    final skill = selectedSkill.value;
    if (skill != null) {
      final localPos = camera.globalToLocal(event.canvasPosition);
      
      if (skill == 'spikes' && coins.value >= 200) {
        coins.value -= 200;
        add(SpikesComponent(position: localPos));
        selectedSkill.value = null;
      } else if (skill == 'tnt' && coins.value >= 500) {
        coins.value -= 500;
        add(TntComponent(position: localPos));
        selectedSkill.value = null;
      }
    }
  }

  Future<void> _preloadAssets() async {
    // Load 5 cấp độ mèo đầu tiên để test
    for (int i = 0; i < 5; i++) {
      final data = catLevels[i];
      final atlas = await AtlasFlutter.fromAsset(data.atlasPath);
      final skeleton = await SkeletonDataFlutter.fromAsset(atlas, data.jsonPath);
      catSpinePool[data.level] = (atlas, skeleton);
    }

    // Load tất cả quái
    for (final eData in enemyRegistry) {
      final eAtlas = await AtlasFlutter.fromAsset(eData.atlasPath);
      final eSkeleton = await SkeletonDataFlutter.fromAsset(eAtlas, eData.jsonPath);
      enemySpinePool[eData.name] = (eAtlas, eSkeleton);
    }
  }

  void _onWaveChange() async {
    int bgIndex = ((currentWave.value - 1) ~/ 5) + 1;
    bgIndex = bgIndex.clamp(1, 5);
    background.sprite = await loadSprite('assets/Png/Area/Area$bgIndex.png');
  }

  void _startWaveManager() {
    add(TimerComponent(
      period: 8, // Mỗi 8 giây một đợt quái
      repeat: true,
      onTick: () {
        if (!isGameOver.value) {
          _spawnWave();
        }
      },
    ));
  }

  void _spawnWave() {
    final isBossWave = currentWave.value % 5 == 0;
    int enemyCount = 3 + (currentWave.value * 2);
    
    if (isBossWave) {
      // Triệu hồi Boss ở cuối wave
      Future.delayed(Duration(seconds: 10), () {
        final bossData = enemyRegistry.where((e) => e.isBoss).toList()[Random().nextInt(7)];
        add(EnemyComponent(data: bossData));
      });
      enemyCount = (enemyCount * 0.7).toInt(); // Giảm quái con khi có boss
    }

    for (int i = 0; i < enemyCount; i++) {
      Future.delayed(Duration(milliseconds: i * 800), () {
        if (isGameOver.value) return;
        
        // Chọn quái thường dựa trên tiến trình wave
        final regs = enemyRegistry.where((e) => !e.isBoss).toList();
        final maxType = (currentWave.value / 2).floor().clamp(1, 8);
        final type = regs[Random().nextInt(maxType)];
        
        add(EnemyComponent(data: type));
      });
    }
    currentWave.value++;
  }

  void _setupPlacementSlots() {
    // Tọa độ điều chỉnh mạnh hơn dựa trên hình ảnh thực tế "Lại lệch"
    // Grid: Dịch sang phải và xuống dưới nhiều hơn
    final gridStartX = 185.0; 
    final gridStartY = 285.0;
    final cellWidth = 162.0;
    final cellHeight = 168.0;

    // 1. Grid Slots (3x3 ô màu trắng)
    for (int col = 0; col < 3; col++) {
      for (int row = 0; row < 3; row++) {
        add(PlacementSlot(
          position: Vector2(gridStartX + col * cellWidth, gridStartY + row * cellHeight),
          size: Vector2(145, 155),
          isWallSlot: false,
        )..priority = 10);
      }
    }

    // 2. Trash Bin Slot (Ô Delete - Dưới Column 2 của grid)
    add(PlacementSlot(
      position: Vector2(gridStartX + 1 * cellWidth, gridStartY + 3 * cellHeight + 5),
      size: Vector2(145, 155),
      isWallSlot: false,
      isDeleteSlot: true,
    )..priority = 10);

    // 3. Wall Slots (5 ô hộp màu cam)
    // Cần dịch sang trái để khớp hộp cam và tránh đè lên thanh máu
    final boxStartX = 425.0; 
    final boxStartY = 220.0; // Bắt đầu từ hộp cam đầu tiên (bỏ qua thùng rác xanh ở trên)
    final boxHeight = 125.0; // Khoảng cách giữa các hộp cam
    
    for (int i = 0; i < 5; i++) {
      add(PlacementSlot(
        position: Vector2(boxStartX, boxStartY + i * boxHeight),
        size: Vector2(130, 120),
        isWallSlot: true,
      )..priority = 10);
    }
  }

  void spawnEnemy() {
    if (isGameOver.value) return;
    add(EnemyComponent(data: enemyRegistry[0]));
  }

  void gameOver() {
    isGameOver.value = true;
    pauseEngine();
    overlays.add('GameOver');
  }

  void reset() {
    score.value = 0;
    coins.value = 100;
    castleHp.value = 1.0;
    isGameOver.value = false;
    
    children.whereType<EnemyComponent>().forEach((e) => e.removeFromParent());
    overlays.remove('GameOver');
    resumeEngine();
  }

  @override
  void onDetach() {
    currentWave.removeListener(_onWaveChange);
    // Dispose Spine pools
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
