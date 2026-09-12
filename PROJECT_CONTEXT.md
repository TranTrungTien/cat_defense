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
├── screens
│   └── game_screen.dart
├── ui
│   └── game_ui.dart
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

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true

  assets:
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
```

### `D:\personal\cat_defense/lib\components\bullet_component.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'enemy_component.dart';
import 'hit_effect.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';

class BulletComponent extends SpriteComponent with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final Vector2 startPosition;
  final EnemyComponent target;
  final CatLevelData data;
  double speed = 800;

  BulletComponent({
    required this.startPosition, 
    required this.target, 
    required this.data
  }) : super(size: Vector2(40, 20), position: startPosition, anchor: Anchor.center);

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

    final direction = (target.position - position).normalized();
    position += direction * speed * dt;
    angle = direction.angleToSigned(Vector2(1, 0)) * -1;

    if (position.distanceTo(target.position) < 20) {
      target.takeDamage(data.damage);
      game.coins.value += 2; // Tấn công ra vàng (PvZ style mod)
      game.add(HitEffect(position: position.clone()));
      removeFromParent();
    }
  }
}
```

### `D:\personal\cat_defense/lib\components\castle_component.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../cat_defense_game.dart';

class CastleComponent extends PositionComponent with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  double maxHp = 1000;
  double currentHp = 1000;

  CastleComponent() : super(priority: 1);

  @override
  Future<void> onLoad() async {
    // Exact dimensions and positioning for the Wall bar in Reference 1
    size = Vector2(80, 700);
    anchor = Anchor.topCenter;
    
    // Transparent area for hitbox
    add(RectangleHitbox());
  }

  void takeDamage(double damage) {
    currentHp -= damage;
    game.castleHp.value = (currentHp / maxHp).clamp(0, 1);
    if (currentHp <= 0) game.gameOver();
  }

  void repair(double amount) {
    if (game.coins.value >= 56780) { // Giá sửa tường theo ảnh
      game.coins.value -= 56780;
      currentHp = (currentHp + amount).clamp(0, maxHp);
      game.castleHp.value = currentHp / maxHp;
    }
  }
}
```

### `D:\personal\cat_defense/lib\components\cat_component.dart`
```dart
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flutter/material.dart' hide Color, Paint, Canvas;
import '../cat_defense_game.dart';
import '../game_data.dart';
import 'enemy_component.dart';
import 'bullet_component.dart';
import 'spine_component.dart';
import 'shoot_fx.dart';
import 'coin_effect.dart';

enum CatState { idle, shoot }

class CatComponent extends SpineComponent with HasGameReference<CatDefenseGame> {
  final CatLevelData data;
  final bool isOnWall; 
  double lastFireTime = 0;
  
  double opacity = 1.0; 

  CatComponent({required this.data, required this.isOnWall}) : super(
    anchor: Anchor.center,
    scale: Vector2(1.1, 1.1),
  );

  @override
  Future<void> onLoad() async {
    final pool = game.catSpinePool[data.level];
    
    if (pool != null) {
      initSpine(SkeletonDrawableFlutter(pool.$1, pool.$2, false));
    } else {
      final atlas = await AtlasFlutter.fromAsset(data.atlasPath);
      final skeleton = await SkeletonDataFlutter.fromAsset(atlas, data.jsonPath);
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation(['Idle', 'idle'], loop: true);
  }

  @override
  void render(Canvas canvas) {
    if (opacity < 1.0) {
      canvas.saveLayer(null, Paint()..color = Colors.white.withAlpha((opacity * 255).toInt()));
      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Luôn ưu tiên tấn công nếu có kẻ địch trong tầm bắn
    _updateCombat(dt);
  }

  void _updateCombat(double dt) {
    lastFireTime += dt;
    if (lastFireTime >= data.fireRate) {
      // Tìm kẻ địch trên toàn bản đồ (hoặc giới hạn tầm bắn)
      final enemies = game.children.whereType<EnemyComponent>()
          .where((e) => e.hp > 0 && e.position.x > absolutePosition.x);
          
      EnemyComponent? target;
      double minDistance = isOnWall ? 1200 : 800; // Tường bắn xa hơn

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
    final shootAnim = skeleton.data.findAnimation('Shoot') ?? skeleton.data.findAnimation('shoot');
    if (shootAnim != null) {
      animationState.setAnimation(0, shootAnim.name, false);
      animationState.addAnimation(0, 'Idle', true, 0);
    }
    
    // Bắn đạn từ vị trí của mèo
    final bulletPos = absolutePosition + Vector2(40, -10);
    game.add(ShootFx(position: bulletPos));
    
    game.add(BulletComponent(
      startPosition: bulletPos,
      target: target,
      data: data,
    ));
  }

  @override
  void onRemove() {
    disposeSpine();
    super.onRemove();
  }
}
```

### `D:\personal\cat_defense/lib\components\coin_effect.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../cat_defense_game.dart';

class CoinEffect extends SpriteComponent with HasGameReference<CatDefenseGame> {
  CoinEffect({required Vector2 position})
      : super(
          position: position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/CoinIcon.png');
    
    add(MoveByEffect(
      Vector2(0, -50),
      EffectController(duration: 0.8, curve: Curves.easeOut),
    ));
    
    add(OpacityEffect.fadeOut(
      EffectController(duration: 0.8, curve: Curves.easeIn),
      onComplete: () => removeFromParent(),
    ));
  }
}
```

### `D:\personal\cat_defense/lib\components\enemy_component.dart`
```dart
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

class EnemyComponent extends SpineComponent with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  final EnemyTypeData data;
  late double hp;
  final _random = Random();
  EnemyState _state = EnemyState.walk;

  EnemyState get state => _state;

  EnemyComponent({required this.data}) : super(
    anchor: Anchor.center,
    scale: data.isBoss ? Vector2(2.5, 2.5) : Vector2(1.1, 1.1), // Boss to lớn hơn
  ) {
    hp = data.hp;
    priority = data.isBoss ? 5 : 2;
  }

  @override
  Future<void> onLoad() async {
    final pool = game.enemySpinePool[data.name];
    
    if (pool != null) {
      initSpine(SkeletonDrawableFlutter(pool.$1, pool.$2, false));
    } else {
      final atlas = await AtlasFlutter.fromAsset(data.atlasPath);
      final skeleton = await SkeletonDataFlutter.fromAsset(atlas, data.jsonPath);
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation(['Walking', 'Walk', 'walking', 'walk'], loop: true);

    final minY = game.size.y * 0.2;
    final maxY = game.size.y * 0.8;
    position = Vector2(game.size.x + 50, minY + _random.nextDouble() * (maxY - minY));
    
    add(RectangleHitbox(size: size * 0.8, position: Vector2(0, 0)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_state == EnemyState.walk) {
      position.x -= data.speed * dt;
    }

    if (position.x < -100) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is CastleComponent && _state != EnemyState.dead) {
      _state = EnemyState.attack;
      setFirstAvailableAnimation(['Attack', 'attack'], loop: true);
      
      add(TimerComponent(
        period: 1.5, // Tốc độ cắn của Zombie
        repeat: true,
        onTick: () {
          if (_state == EnemyState.attack) {
            other.takeDamage(10); // Sát thương mặc định của quái
          }
        },
      ));
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
    
    // Hiển thị hiệu ứng nhận vàng ngay tại vị trí quái chết
    game.add(CoinEffect(position: position + Vector2(0, -30)));
    
    // Tìm animation Dead hoặc dead
    final deadAnim = skeleton.data.findAnimation('Dead') ?? skeleton.data.findAnimation('dead');
    if (deadAnim != null) {
      final entry = animationState.setAnimation(0, deadAnim.name, false);
      entry.setListener((type, entry, event) {
        if (type == EventType.complete && entry.animation.name == deadAnim.name) {
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
  }
}
```

### `D:\personal\cat_defense/lib\components\hit_effect.dart`
```dart
import 'package:flame/components.dart';
import '../cat_defense_game.dart';

class HitEffect extends SpriteAnimationComponent with HasGameReference<CatDefenseGame> {
  HitEffect({required Vector2 position}) : super(
    position: position,
    size: Vector2(60, 60),
    anchor: Anchor.center,
    removeOnFinish: true,
  );

  @override
  Future<void> onLoad() async {
    final frames = <Sprite>[];
    for (var i = 0; i <= 19; i++) {
      frames.add(await game.loadSprite('assets/Png/Explosion/ExplosionFx-Explossion_${i.toString().padLeft(2, '0')}.png'));
    }
    animation = SpriteAnimation.spriteList(frames, stepTime: 0.04, loop: false);
  }
}
```

### `D:\personal\cat_defense/lib\components\placement_slot.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';
import 'cat_component.dart';

class PlacementSlot extends PositionComponent with HasGameReference<CatDefenseGame>, TapCallbacks {
  final bool isWallSlot; 
  final bool isDeleteSlot;
  bool isOccupied = false;
  CatComponent? residentCat;
  CatComponent? ghostCat; 

  PlacementSlot({
    required Vector2 position,
    required Vector2 size,
    this.isWallSlot = false,
    this.isDeleteSlot = false,
  }) : super(position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    
    // Không cho phép đặt mèo vào ô Delete
    if (isDeleteSlot) return;

    final selectedCat = game.selectedCatData.value;
    
    if (selectedCat != null && !isOccupied) {
      if (ghostCat == null) {
        ghostCat = CatComponent(data: selectedCat, isOnWall: isWallSlot)
          ..position = size / 2 // Position relative to slot
          ..opacity = 0.5;
        add(ghostCat!); // Add as child of slot for better alignment
      } else if (ghostCat!.data.level != selectedCat.level) {
        ghostCat?.removeFromParent();
        ghostCat = null;
      }
    } else {
      if (ghostCat != null) {
        ghostCat?.removeFromParent();
        ghostCat = null;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isDeleteSlot) {
      // Logic xóa mèo đang chọn hoặc có thể tap vào mèo đã đặt để xóa (cần logic thêm)
      game.selectedCatData.value = null;
      return;
    }

    final selectedCat = game.selectedCatData.value;
    
    if (selectedCat != null && !isOccupied && game.coins.value >= selectedCat.cost) {
      game.coins.value -= selectedCat.cost;
      _placeCat(selectedCat);
      game.selectedCatData.value = null;
    } else if (isOccupied && residentCat != null && game.selectedCatData.value == null) {
      // Nếu tap vào ô đã có mèo mà không chọn mèo nào -> Có thể bán/xóa
      residentCat?.removeFromParent();
      residentCat = null;
      isOccupied = false;
    }
  }

  void _placeCat(CatLevelData data) {
    final cat = CatComponent(data: data, isOnWall: isWallSlot)
      ..position = size / 2;
    add(cat); // Add as child of slot
    residentCat = cat;
    isOccupied = true;
    
    ghostCat?.removeFromParent();
    ghostCat = null;
  }
}
```

### `D:\personal\cat_defense/lib\components\shoot_fx.dart`
```dart
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
```

### `D:\personal\cat_defense/lib\components\skills\spikes_component.dart`
```dart
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../enemy_component.dart';
import '../../cat_defense_game.dart';

class SpikesComponent extends SpriteComponent with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  double damage = 10;
  double interval = 0.5;
  double timer = 0;
  final Set<EnemyComponent> enemiesInRange = {};

  SpikesComponent({required Vector2 position}) : super(
    position: position,
    size: Vector2(80, 80),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/AddonIcon1.png'); // Placeholder icon cho Chông
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
    if (timer >= interval) {
      for (final enemy in enemiesInRange) {
        if (enemy.isMounted) {
          enemy.takeDamage(damage);
        }
      }
      timer = 0;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
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
import '../enemy_component.dart';
import '../hit_effect.dart';
import '../../cat_defense_game.dart';

class TntComponent extends SpriteComponent with HasGameReference<CatDefenseGame> {
  double damage = 200;
  double explosionRadius = 250;
  double fuseTime = 2.0;

  TntComponent({required Vector2 position}) : super(
    position: position,
    size: Vector2(100, 100),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/Png/Ui/AddonIcon2.png'); // Placeholder icon cho TNT
    
    // Đếm ngược nổ
    add(TimerComponent(
      period: fuseTime,
      onTick: explode,
    ));
  }

  void explode() {
    // Hiệu ứng nổ
    game.add(HitEffect(position: position.clone())..size = Vector2(300, 300));
    
    // Gây sát thương diện rộng
    final enemies = game.children.whereType<EnemyComponent>();
    for (final enemy in enemies) {
      if (position.distanceTo(enemy.position) <= explosionRadius) {
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
      // Translate to center the skeleton bounds relative to the component's center
      canvas.translate(-_bounds.x - _bounds.width / 2, -_bounds.y - _bounds.height / 2);
      _drawable.renderToCanvas(canvas);
      canvas.restore();
    }
  }

  AnimationState get animationState => _drawable.animationState;
  AnimationStateData get animationStateData => _drawable.animationStateData;
  Skeleton get skeleton => _drawable.skeleton;

  /// Thử phát một danh sách các tên animation, cái nào tồn tại đầu tiên sẽ được dùng.
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

### `D:\personal\cat_defense/lib\game_data.dart`
```dart
class CatLevelData {
  final int level;
  final String name;
  final int cost;
  final int upgradeCost;
  final double damage;
  final double fireRate;
  final String bulletSprite;
  final String atlasPath;
  final String jsonPath;

  CatLevelData({
    required this.level,
    required this.name,
    required this.cost,
    required this.upgradeCost,
    required this.damage,
    required this.fireRate,
    required this.bulletSprite,
    required this.atlasPath,
    required this.jsonPath,
  });
}

class EnemyTypeData {
  final String name;
  final double hp;
  final double speed;
  final int reward;
  final bool isBoss;
  final String atlasPath;
  final String jsonPath;

  EnemyTypeData({
    required this.name,
    required this.hp,
    required this.speed,
    required this.reward,
    required this.isBoss,
    required this.atlasPath,
    required this.jsonPath,
  });
}

// Registry cho 15 loại Mèo
final List<CatLevelData> catLevels = List.generate(15, (i) {
  final lv = i + 1;
  String bSprite = 'assets/Png/Bullets/Artboard_1.png';
  if (lv > 5) bSprite = 'assets/Png/Bullets/Artboard_1_copy.png';
  if (lv > 10) bSprite = 'assets/Png/Bullets/Artboard_1_copy_2.png';

  return CatLevelData(
    level: lv,
    name: 'Cat $lv',
    cost: 500 * lv,
    upgradeCost: 300 * lv,
    damage: 10.0 + (i * 5),
    fireRate: (1.2 - (i * 0.05)).clamp(0.4, 1.2),
    bulletSprite: bSprite,
    atlasPath: 'Json_Atlas/Cat_Characters/Cat$lv/Character$lv.atlas',
    jsonPath: 'Json_Atlas/Cat_Characters/Cat$lv/Character$lv.json',
  );
});

// Registry cho 8 Zombie thường và 7 Boss
final List<EnemyTypeData> enemyRegistry = [
  ...List.generate(8, (i) {
    final idx = i + 1;
    return EnemyTypeData(
      name: 'Zombie Reg $idx',
      hp: 50.0 + (i * 30),
      speed: 80.0 - (i * 2),
      reward: 20 + (i * 10),
      isBoss: false,
      atlasPath: 'Json_Atlas/Enemies/Enemy_Reg_$idx/Enemy.atlas',
      jsonPath: 'Json_Atlas/Enemies/Enemy_Reg_$idx/Enemy.json',
    );
  }),
  ...List.generate(7, (i) {
    final idx = i + 1;
    return EnemyTypeData(
      name: 'Boss $idx',
      hp: 1000.0 + (i * 500),
      speed: 50.0 - (i * 3),
      reward: 500 + (i * 200),
      isBoss: true,
      atlasPath: 'Json_Atlas/Enemies/Enemy_Boss_$idx/Enemy.atlas',
      jsonPath: 'Json_Atlas/Enemies/Enemy_Boss_$idx/Enemy.json',
    );
  }),
];
```

### `D:\personal\cat_defense/lib\main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set to fullscreen
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Defense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}
```

### `D:\personal\cat_defense/lib\screens\game_screen.dart`
```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../cat_defense_game.dart';
import '../ui/game_ui.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

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
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'GameOver': (context, game) => GameOverMenu(game: _game),
            },
          ),
          GameUI(game: _game),
        ],
      ),
    );
  }
}

class GameOverMenu extends StatelessWidget {
  final CatDefenseGame game;
  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = constraints.maxWidth / 1280;
        
        return Center(
          child: Container(
            width: 400 * scale,
            height: 300 * scale,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Png/Ui/LosePopUp.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60 * scale), // Space for "YOU LOSE" text in image
                ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (context, score, child) {
                    return Text(
                      'Score: $score',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 24 * scale, 
                        fontWeight: FontWeight.bold
                      ),
                    );
                  },
                ),
                SizedBox(height: 20 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        game.overlays.remove('GameOver');
                        game.reset();
                      },
                      child: Image.asset('assets/Png/Ui/BtnGreen.png', width: 120 * scale),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### `D:\personal\cat_defense/lib\ui\game_ui.dart`
```dart
import 'package:flutter/material.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';

class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = constraints.maxWidth / 1920;
        
        return SafeArea(
          child: Stack(
            children: [
              // Top Left: Coins
              Positioned(
                top: 30 * scale,
                left: 30 * scale,
                child: _buildDesignInfoBar(
                  iconPath: 'assets/Png/Ui/CoinIcon.png',
                  valueNotifier: game.coins,
                  scale: scale,
                ),
              ),

              // Top Right: Wave info
              Positioned(
                top: 30 * scale,
                right: 120 * scale,
                child: Container(
                  width: 280 * scale,
                  height: 75 * scale,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Png/Ui/WaveBar.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/Png/Ui/DaillyIcon.png', width: 45 * scale), 
                        SizedBox(width: 10 * scale),
                        ValueListenableBuilder<int>(
                          valueListenable: game.currentWave,
                          builder: (context, wave, _) => Text(
                            'Wave $wave / 10',
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 26 * scale, 
                              fontWeight: FontWeight.bold,
                              shadows: const [Shadow(blurRadius: 2, offset: Offset(2, 2))],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Right: Skills (Spikes, TNT, Boxing)
              Positioned(
                bottom: 30 * scale,
                right: 30 * scale,
                child: Row(
                  children: [
                    _buildSkillButton('assets/Png/Ui/AddonIcon1.png', '2/5', scale),
                    SizedBox(width: 20 * scale),
                    _buildSkillButton('assets/Png/Ui/AddonIcon2.png', '3/5', scale),
                    SizedBox(width: 20 * scale),
                    _buildSkillButton('assets/Png/Ui/AddonIcon3.png', '2/5', scale),
                  ],
                ),
              ),

              // Bottom Left: Action Buttons (Cat Level & Repair)
              Positioned(
                bottom: 30 * scale,
                left: 30 * scale,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Cat Level Button (Green)
                    GestureDetector(
                      onTap: () {
                        // Logic chọn mèo level 3
                        game.selectedCatData.value = catLevels[2];
                      },
                      child: _buildMainActionButton(
                        iconPath: 'assets/Png/Ui/Uplogo3.png',
                        title: 'Level 3',
                        price: '56780',
                        color: Colors.green,
                        scale: scale,
                      ),
                    ),
                    SizedBox(width: 20 * scale),
                    // Repair Wall Button (Orange)
                    GestureDetector(
                      onTap: () => game.castle.repair(200),
                      child: _buildMainActionButton(
                        iconPath: 'assets/Png/Ui/WallIcon.png',
                        title: 'Repair Wall',
                        price: '56780',
                        color: Colors.orange,
                        scale: scale,
                      ),
                    ),
                    SizedBox(width: 25 * scale),
                    // Trash Bin
                    Image.asset('assets/Png/Ui/BtnHelpOff.png', width: 90 * scale),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesignInfoBar({
    required String iconPath,
    required ValueNotifier<int> valueNotifier,
    required double scale,
  }) {
    return Container(
      width: 260 * scale,
      height: 70 * scale,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Png/Ui/GemsBarBg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10 * scale),
          Image.asset(iconPath, width: 50 * scale),
          SizedBox(width: 15 * scale),
          ValueListenableBuilder<int>(
            valueListenable: valueNotifier,
            builder: (context, value, _) => Text(
              '$value',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 30 * scale, 
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(blurRadius: 2, offset: Offset(2, 2))],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillButton(String iconPath, String count, double scale) {
    return Container(
      width: 130 * scale,
      height: 130 * scale,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Png/Ui/YellowBox.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Center(child: Image.asset(iconPath, width: 90 * scale)),
          Positioned(
            right: 8 * scale,
            bottom: 8 * scale,
            child: Text(
              count, 
              style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.w900, 
                fontSize: 22 * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionButton({
    required String iconPath,
    required String title,
    required String price,
    required Color color,
    required double scale,
  }) {
    return Container(
      width: 310 * scale,
      height: 115 * scale,
      padding: EdgeInsets.symmetric(horizontal: 15 * scale, vertical: 10 * scale),
      decoration: BoxDecoration(
        color: color.withAlpha(235),
        borderRadius: BorderRadius.circular(25 * scale),
        border: Border.all(color: Colors.white, width: 5 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 4, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 85 * scale),
          SizedBox(width: 15 * scale),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: TextStyle(color: Colors.white, fontSize: 24 * scale, fontWeight: FontWeight.w900),
              ),
              Row(
                children: [
                  Image.asset('assets/Png/Ui/CoinIcon.png', width: 28 * scale),
                  SizedBox(width: 8 * scale),
                  Text(
                    price, 
                    style: TextStyle(color: Colors.yellow, fontSize: 26 * scale, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

