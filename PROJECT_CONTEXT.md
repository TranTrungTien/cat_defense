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
import 'package:flame/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, SystemChrome, SystemUiMode;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spine_flutter/spine_flutter.dart';
import 'components/bullet_component.dart';
import 'components/castle_component.dart';
import 'components/enemy_component.dart';
import 'components/placement_slot.dart';
import 'components/skills/spikes_component.dart';
import 'components/skills/tnt_component.dart';
import 'game_data.dart';
import 'config/game_layout.dart';

class CatDefenseGame extends FlameGame
    with HasCollisionDetection, TapCallbacks {
  static final Vector2 logicalSize = Vector2(1920, 1080);
  static const int totalWaves = 10;
  static const int initialCoins = 5000;

  /// BAT true de:
  ///   - ve khung do quanh moi slot
  ///   - KEO THA slot cho khop art, tha tay -> JSON in ra console
  /// NHOT QUEN dat false khi release.
  static const bool showLayoutDebug = false;

  static const Map<String, int> skillCosts = {'spikes': 200, 'tnt': 500};

  late CastleComponent castle;
  late SpriteComponent background;

  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> coins = ValueNotifier(initialCoins);
  final ValueNotifier<double> castleHp = ValueNotifier(1.0);
  final ValueNotifier<bool> isGameOver = ValueNotifier(false);
  final ValueNotifier<int> currentWave = ValueNotifier(1);

  final ValueNotifier<CatLevelData?> selectedCatData = ValueNotifier(null);
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
  bool _hasRequestedFullscreen = false;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: logicalSize);
    images.prefix = '';
    await initSpineFlutter();

    await _loadLayoutConfig();
    await _preloadAssets();
    await _preloadFx();

    background = SpriteComponent()
      ..sprite = await loadSprite('assets/Png/Area/Area1.png')
      ..size = logicalSize;
    add(background);

    currentWave.addListener(_onWaveChange);

    castle = CastleComponent()..position = GameLayout.castlePosition;
    add(castle);

    _setupPlacementSlots();
    _startWaveManager();
  }

  /// Ưu tiên assets/layout.json (kết quả calibrate), thất bại thì dùng defaults.
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
    // Với bản Web, yêu cầu Fullscreen ở lần chạm đầu tiên
    if (kIsWeb && !_hasRequestedFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      _hasRequestedFullscreen = true;
    }

    super.onTapDown(event);

    final skill = selectedSkill.value;
    if (skill == null) return;

    final localPos = camera.globalToLocal(event.canvasPosition);

    if (localPos.x < 640) {
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
    for (int i = 0; i < 6; i++) {
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
  }

  void _onWaveChange() async {
    int bgIndex = ((currentWave.value - 1) ~/ 5) + 1;
    bgIndex = bgIndex.clamp(1, 5);
    background.sprite = await loadSprite('assets/Png/Area/Area$bgIndex.png');
  }

  void _startWaveManager() {
    add(
      TimerComponent(
        period: 8,
        repeat: true,
        onTick: () {
          if (!isGameOver.value) _spawnWave();
        },
      ),
    );
  }

  void _spawnWave() {
    final waveNumber = currentWave.value;
    final isBossWave = waveNumber % 5 == 0;
    int enemyCount = 3 + (waveNumber * 2);

    if (isBossWave) {
      Future.delayed(const Duration(seconds: 10), () {
        if (isGameOver.value) return;
        final bosses = enemyRegistry.where((e) => e.isBoss).toList();
        add(EnemyComponent(data: bosses[Random().nextInt(bosses.length)]));
      });
      enemyCount = (enemyCount * 0.7).toInt();
    }

    for (int i = 0; i < enemyCount; i++) {
      Future.delayed(Duration(milliseconds: i * 800), () {
        if (isGameOver.value) return;
        final regs = enemyRegistry.where((e) => !e.isBoss).toList();
        final maxType = (waveNumber / 2).floor().clamp(1, 8);
        add(EnemyComponent(data: regs[Random().nextInt(maxType)]));
      });
    }

    currentWave.value = waveNumber + 1;
  }

  /// Toàn bộ slot sinh ra từ GameLayout (defaults hoặc layout.json).
  /// Priority: delete (30) > wall (20) > grid (10)
  /// -> vùng chồng lấn vẫn đặt được meo len wall.
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

  void reset() {
    score.value = 0;
    coins.value = initialCoins;
    castleHp.value = 1.0;
    isGameOver.value = false;
    currentWave.value = 1;
    selectedCatData.value = null;
    selectedSkill.value = null;
    skillCounts.value = {'spikes': 2, 'tnt': 3};
    hoveredSlot = null;

    castle.reset();

    children.whereType<EnemyComponent>().forEach((e) => e.removeFromParent());
    children.whereType<BulletComponent>().forEach((b) => b.removeFromParent());
    children.whereType<SpikesComponent>().forEach((s) => s.removeFromParent());
    children.whereType<TntComponent>().forEach((t) => t.removeFromParent());
    children.whereType<PlacementSlot>().forEach((s) => s.reset());

    overlays.remove('GameOver');
    overlays.remove('Pause');
    resumeEngine();
  }

  @override
  void onDetach() {
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
import 'enemy_component.dart';
import 'hit_effect.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';

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
         size: Vector2(65, 35),
         position: startPosition,
         anchor: Anchor.center,
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

class CastleComponent extends PositionComponent
    with HasGameReference<CatDefenseGame>, CollisionCallbacks {
  // FIX: gia hop ly, gan voi UI
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
import '../cat_defense_game.dart';
import '../game_data.dart';
import '../config/game_layout.dart';
import 'enemy_component.dart';
import 'bullet_component.dart';
import 'spine_component.dart';
import 'shoot_fx.dart';

enum CatState { idle, shoot }

class CatComponent extends SpineComponent
    with HasGameReference<CatDefenseGame> {
  final CatLevelData data;
  final bool isOnWall;
  double lastFireTime = 0;

  double opacity = 1.0;

  CatComponent({required this.data, required this.isOnWall})
    : super(anchor: Anchor.center, scale: Vector2(1.1, 1.1));

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
      initSpine(SkeletonDrawableFlutter(atlas, skeleton, false));
    }

    setFirstAvailableAnimation(['Idle', 'idle'], loop: true);
  }

  /// ============================================================
  /// FEET-ANCHORING: sau khi mount (size skeleton da biet),
  /// tu canh meo trong slot cha:
  ///   - Nam giua theo chieu NGANG
  ///   - CHAN (day skeleton) cach canh duoi slot 1 khoang nho
  ///     (gridFootPadding / wallFootPadding trong GameLayout)
  /// Khong con phu thuoc vao ty le skeleton cua tung con meo.
  /// ============================================================
  @override
  void onMount() {
    super.onMount();
    _fitFeetIntoSlot();
  }

  void _fitFeetIntoSlot() {
    final p = parent;
    // Chi tu canh khi nam trong 1 slot (PositionComponent cha).
    // Quai dung chung SpineComponent nhung parent la game -> bo qua.
    if (p is! PositionComponent) return;

    final pad = isOnWall
        ? GameLayout.wallFootPadding
        : GameLayout.gridFootPadding;
    // Kich thuoc visual thuc te sau khi ap scale
    final visualH = size.y * scale.y;
    // anchor = center -> `position` là TÂM của mèo trong không gian của slot.
    // Căn giữa theo phương ngang (X) dựa trên tâm ô + độ lệch tinh chỉnh riêng của từng con.
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
    _updateCombat(dt);
  }

  void _updateCombat(double dt) {
    lastFireTime += dt;
    if (lastFireTime >= data.fireRate) {
      final enemies = game.children.whereType<EnemyComponent>().where(
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

    // FIX: sau khi SpineComponent ton trong anchor, absolutePosition
    // chinh la TAM visual cua meo. Dau sung = tam + muzzleOffset
    // (chinh trong game_data.dart neu con lech).
    final bulletPos = absolutePosition + Vector2(data.muzzleX, data.muzzleY);
    game.add(ShootFx(position: bulletPos));
    game.add(
      BulletComponent(startPosition: bulletPos, target: target, data: data),
    );
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
  final _random = Random();
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

    if (_state == EnemyState.walk &&
        position.x < game.castle.position.x - 120) {
      game.castle.takeDamage(10);
      game.showToast('An enemy breached the wall!');
      removeFromParent();
      return;
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
  }
}
```

### `D:\personal\cat_defense/lib\components\hit_effect.dart`
```dart
import 'package:flame/components.dart';
import '../cat_defense_game.dart';

class HitEffect extends SpriteAnimationComponent
    with HasGameReference<CatDefenseGame> {
  HitEffect({required Vector2 position, Vector2? effectSize})
    : super(
        position: position,
        size: effectSize ?? Vector2(150, 150),
        anchor: Anchor.center,
        removeOnFinish: true,
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
import '../cat_defense_game.dart';
import '../game_data.dart';
import '../config/game_layout.dart';
import 'cat_component.dart';

class PlacementSlot extends PositionComponent
    with
        HasGameReference<CatDefenseGame>,
        TapCallbacks,
        HoverCallbacks,
        DragCallbacks {
  /// Id trong GameLayout (vd: 'g_0_1', 'w_3', 'delete') — dùng để lưu
  /// lại vị trí khi kéo thả calibrate.
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
        ghostCat = CatComponent(data: selectedCat, isOnWall: isWallSlot)
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
    } else if (isOccupied && residentCat != null && selectedCat == null) {
      final refund = (residentCat!.data.cost * 0.5).round();
      game.coins.value += refund;
      game.showToast('Sold! +$refund');
      residentCat?.removeFromParent();
      residentCat = null;
      isOccupied = false;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (game.hoveredSlot == this) game.hoveredSlot = null;
  }

  // ============================================================
  // CHE DO CALIBRATE: khi CatDefenseGame.showLayoutDebug = true,
  // keo tha slot de ghep dung art. Tha tay -> in JSON ra console.
  // Khi debug = false, drag bi bo qua hoan toan (game choi binh thuong).
  // ============================================================
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!CatDefenseGame.showLayoutDebug) return;
    // Bat dau keo — khong can xu ly gi them
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
    debugPrint('=== LAYOUT EXPORT — copy vao assets/layout.json ===');
    debugPrint(GameLayout.exportJson());
    game.showToast(
      '$layoutId -> (${center.x.round()}, ${center.y.round()}) — xem console',
    );
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
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

  void reset() {
    residentCat?.removeFromParent();
    residentCat = null;
    isOccupied = false;
    ghostCat?.removeFromParent();
    ghostCat = null;
  }
}
```

### `D:\personal\cat_defense/lib\components\shoot_fx.dart`
```dart
import 'package:flame/components.dart';
import '../cat_defense_game.dart';

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
import '../enemy_component.dart';
import '../../cat_defense_game.dart';

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
import '../enemy_component.dart';
import '../hit_effect.dart';
import '../../cat_defense_game.dart';

class TntComponent extends SpriteComponent
    with HasGameReference<CatDefenseGame> {
  double damage = 200;
  double explosionRadius = 250;
  double fuseTime = 2.0;

  TntComponent({required Vector2 position})
    : super(position: position, size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(
      'assets/Png/Ui/AddonIcon2.png',
    ); // Placeholder icon cho TNT

    // Đếm ngược nổ
    add(TimerComponent(period: fuseTime, onTick: explode));
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
class CatLevelData {
  final int level;
  final String name;
  final int cost;
  final int upgradeCost;
  final double damage;
  final double fireRate;
  final String bulletSprite;

  /// Vi tri dau sung so voi TAM meo (dung de spawn dan / hieu ung ban).
  /// Don vi: pixel trong world 1920x1080. Chinh neu dan van lech.
  final double muzzleX;
  final double muzzleY;

  /// Dung de tinh chinh vi tri than meo trong o (vi moi con co khung Spine rong hep khac nhau)
  final double visualOffsetX;
  final double visualOffsetY;

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
    this.muzzleX = 45,
    this.muzzleY = -15,
    this.visualOffsetX = 0,
    this.visualOffsetY = 0,
    required this.atlasPath,
    required this.jsonPath,
  });
}

// ... (EnemyTypeData stays same) ...
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

// Bang tinh chinh cho tung loai meo (vi moi con co art khac nhau hoan toan)
// Neu thay con nao dung lech, hoac ban dan lech thi sua o day.
final Map<int, Map<String, double>> _catFineTune = {
  1: {'mx': 50, 'my': -65, 'vx': 12, 'vy': 0}, // Meo xam, sung cam gio cao
  2: {'mx': 45, 'my': -15, 'vx': 0, 'vy': 0},  // Meo vang, mu hong
  3: {'mx': 45, 'my': -15, 'vx': 0, 'vy': 0},
  // Them cac level khac vao day de tinh chinh...
};

// Registry cho 15 loai Meo
final List<CatLevelData> catLevels = List.generate(15, (i) {
  final lv = i + 1;
  String bSprite = 'assets/Png/Bullets/Artboard_1.png';
  if (lv > 5) bSprite = 'assets/Png/Bullets/Artboard_1_copy.png';
  if (lv > 10) bSprite = 'assets/Png/Bullets/Artboard_1_copy_2.png';

  final tune = _catFineTune[lv] ?? {};

  return CatLevelData(
    level: lv,
    name: 'Cat $lv',
    cost: 500 * lv,
    upgradeCost: 300 * lv,
    damage: 10.0 + (i * 5),
    fireRate: (1.2 - (i * 0.05)).clamp(0.4, 1.2),
    bulletSprite: bSprite,
    muzzleX: tune['mx'] ?? 45,
    muzzleY: tune['my'] ?? -15,
    visualOffsetX: tune['vx'] ?? 0,
    visualOffsetY: tune['vy'] ?? 0,
    atlasPath: 'Json_Atlas/Cat_Characters/Cat$lv/Character$lv.atlas',
    jsonPath: 'Json_Atlas/Cat_Characters/Cat$lv/Character$lv.json',
  );
});

// Registry cho 8 Zombie thuong va 7 Boss
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

  // Cố định hướng màn hình ngang (Landscape) cho App mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Ẩn thanh trạng thái và thanh điều hướng (Fullscreen) cho App mobile
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
      home: const GameScreen(),
    );
  }
}
```

### `D:\personal\cat_defense/lib\screens\game_screen.dart`
```dart
import 'dart:math';
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
              'Pause': (context, game) => PauseMenu(game: _game),
            },
          ),
          GameUI(game: _game),
        ],
      ),
    );
  }
}

/// Scale dung cho overlay: FIT theo ca 2 chieu (giong GameUI),
/// Center tu can giua theo khung game vi game duoc letterbox giua man hinh.
double _fitScale(BoxConstraints c) =>
    min(c.maxWidth / 1920.0, c.maxHeight / 1080.0);

class GameOverMenu extends StatelessWidget {
  final CatDefenseGame game;
  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = _fitScale(constraints);

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
                SizedBox(height: 60 * scale),
                ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (context, score, child) {
                    return Text(
                      'Score: $score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24 * scale,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20 * scale),
                GestureDetector(
                  onTap: () => game.reset(),
                  child: Image.asset(
                    'assets/Png/Ui/BtnGreen.png',
                    width: 120 * scale,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PauseMenu extends StatelessWidget {
  final CatDefenseGame game;
  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = _fitScale(constraints);

        return Container(
          color: Colors.black.withAlpha(160),
          child: Center(
            child: Container(
              width: 420 * scale,
              padding: EdgeInsets.all(28 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24 * scale),
                border: Border.all(color: Colors.orange, width: 6 * scale),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PAUSED',
                    style: TextStyle(
                      fontSize: 40 * scale,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  SizedBox(height: 30 * scale),
                  _menuButton(scale, 'RESUME', Colors.green, () {
                    game.overlays.remove('Pause');
                    game.resumeEngine();
                  }),
                  SizedBox(height: 16 * scale),
                  _menuButton(scale, 'RESTART', Colors.orange, () {
                    game.reset();
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _menuButton(
    double scale,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14 * scale),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16 * scale),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26 * scale,
              fontWeight: FontWeight.w900,
            ),
          ),
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
import '../cat_defense_game.dart';
import '../components/castle_component.dart';
import '../game_data.dart';

/// ============================================================
/// RESPONSIVE UI:
/// - Game world LUON la 1920x1080 (FixedResolutionViewport) va duoc
///   letterbox GIUA man hinh vat ly.
/// - UI khong duoc tinh theo full man hinh (cu) ma phai nam TRONG
///   khung game: scale = min(w/1920, h/1080), cong them offset
///   letterbox. Nho do tren moi thiet bi (mobile 19.5:9, laptop
///   16:10, tablet...) UI luon trung khop voi the gioi game.
/// ============================================================
class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = min(
          constraints.maxWidth / CatDefenseGame.logicalSize.x,
          constraints.maxHeight / CatDefenseGame.logicalSize.y,
        );
        final double gameW = CatDefenseGame.logicalSize.x * scale;
        final double gameH = CatDefenseGame.logicalSize.y * scale;
        final double offX = (constraints.maxWidth - gameW) / 2;
        final double offY = (constraints.maxHeight - gameH) / 2;

        return Stack(
          children: [
            Positioned(
              left: offX,
              top: offY,
              width: gameW,
              height: gameH,
              child: _buildHud(scale),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHud(double scale) {
    return Stack(
      children: [
        // Dai HUD duoi cung
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 185 * scale,
            color: Colors.black.withAlpha(150),
          ),
        ),

        // Top-left: coins + castle HP
        Positioned(top: 24 * scale, left: 24 * scale, child: _coinBar(scale)),
        Positioned(
          top: 104 * scale,
          left: 24 * scale,
          child: _castleHpBar(scale),
        ),

        // Top-right: wave + settings
        Positioned(
          top: 24 * scale,
          right: 24 * scale,
          child: Row(
            children: [
              _waveBar(scale),
              SizedBox(width: 14 * scale),
              _iconButton(
                scale,
                icon: Icons.settings,
                onTap: () {
                  game.pauseEngine();
                  game.overlays.add('Pause');
                },
              ),
            ],
          ),
        ),

        // Bottom: shop meo
        Positioned(
          bottom: 18 * scale,
          left: 20 * scale,
          right: 520 * scale,
          child: _shopBar(scale),
        ),

        // Bottom-right: skills + repair
        Positioned(
          bottom: 24 * scale,
          right: 24 * scale,
          child: Row(
            children: [
              _skillButton(
                scale,
                skillKey: 'spikes',
                iconPath: 'assets/Png/Ui/AddonIcon1.png',
                cost: CatDefenseGame.skillCosts['spikes']!,
              ),
              SizedBox(width: 14 * scale),
              _skillButton(
                scale,
                skillKey: 'tnt',
                iconPath: 'assets/Png/Ui/AddonIcon2.png',
                cost: CatDefenseGame.skillCosts['tnt']!,
              ),
              SizedBox(width: 14 * scale),
              _repairButton(scale),
            ],
          ),
        ),

        _cancelSelection(scale),
        _toast(scale),
      ],
    );
  }

  // ---------- COINS ----------
  Widget _coinBar(double scale) {
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
          Image.asset('assets/Png/Ui/CoinIcon.png', width: 50 * scale),
          SizedBox(width: 15 * scale),
          ValueListenableBuilder<int>(
            valueListenable: game.coins,
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

  // ---------- CASTLE HP ----------
  Widget _castleHpBar(double scale) {
    return ValueListenableBuilder<double>(
      valueListenable: game.castleHp,
      builder: (context, hp, _) => Container(
        width: 260 * scale,
        height: 26 * scale,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(170),
          borderRadius: BorderRadius.circular(13 * scale),
          border: Border.all(
            color: Colors.white.withAlpha(120),
            width: 2 * scale,
          ),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: hp.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: hp > 0.3 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(11 * scale),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- WAVE ----------
  Widget _waveBar(double scale) {
    return Container(
      width: 260 * scale,
      height: 70 * scale,
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
            Image.asset('assets/Png/Ui/DaillyIcon.png', width: 42 * scale),
            SizedBox(width: 10 * scale),
            ValueListenableBuilder<int>(
              valueListenable: game.currentWave,
              builder: (context, wave, _) => Text(
                'Wave ${min(wave, CatDefenseGame.totalWaves)} / ${CatDefenseGame.totalWaves}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * scale,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(blurRadius: 2, offset: Offset(2, 2))],
                ),
              ),
            ),
          ],
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
        width: 70 * scale,
        height: 70 * scale,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(230),
          borderRadius: BorderRadius.circular(14 * scale),
          border: Border.all(color: Colors.black26, width: 2),
        ),
        child: Icon(icon, size: 38 * scale, color: Colors.black87),
      ),
    );
  }

  // ---------- SHOP MEO ----------
  Widget _shopBar(double scale) {
    final cats = catLevels.take(6).toList();
    return SizedBox(
      height: 150 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (context, index) => SizedBox(width: 12 * scale),
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
              child: Container(
                width: 118 * scale,
                height: 150 * scale,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange.shade400
                      : Colors.white.withAlpha(235),
                  borderRadius: BorderRadius.circular(16 * scale),
                  border: Border.all(
                    color: isSelected ? Colors.yellow : Colors.white,
                    width: 4 * scale,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pets,
                      size: 44 * scale,
                      color: isSelected ? Colors.white : Colors.orange.shade700,
                    ),
                    Text(
                      'Lv ${data.level}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20 * scale,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Png/Ui/CoinIcon.png',
                          width: 20 * scale,
                        ),
                        SizedBox(width: 4 * scale),
                        Text(
                          '${data.cost}',
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w700,
                            color: !afford
                                ? Colors.red
                                : (isSelected ? Colors.white : Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------- SKILL ----------
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
                      width: 124 * scale,
                      height: 150 * scale,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/Png/Ui/YellowBox.png'),
                          fit: BoxFit.fill,
                        ),
                        border: isSel
                            ? Border.all(color: Colors.red, width: 5 * scale)
                            : null,
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(iconPath, width: 78 * scale),
                          ),
                          Positioned(
                            right: 8 * scale,
                            bottom: 6 * scale,
                            child: Text(
                              '$left',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22 * scale,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8 * scale,
                            bottom: 6 * scale,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/Png/Ui/CoinIcon.png',
                                  width: 18 * scale,
                                ),
                                Text(
                                  '$cost',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16 * scale,
                                  ),
                                ),
                              ],
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

  // ---------- REPAIR ----------
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
              onTap: () {
                if (hp >= 1.0) {
                  game.showToast('Wall is already full HP!');
                  return;
                }
                game.castle.repair();
              },
              child: Opacity(
                opacity: usable ? 1 : 0.5,
                child: Container(
                  width: 130 * scale,
                  height: 150 * scale,
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(240),
                    borderRadius: BorderRadius.circular(16 * scale),
                    border: Border.all(color: Colors.white, width: 4 * scale),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Png/Ui/WallIcon.png',
                        width: 58 * scale,
                      ),
                      Text(
                        'Repair',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18 * scale,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Png/Ui/CoinIcon.png',
                            width: 18 * scale,
                          ),
                          Text(
                            '${cost.toInt()}',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.w800,
                              fontSize: 16 * scale,
                            ),
                          ),
                        ],
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

  // ---------- CANCEL SELECTION ----------
  Widget _cancelSelection(double scale) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (context, cat, _) => ValueListenableBuilder<String?>(
        valueListenable: game.selectedSkill,
        builder: (context, skill, _) {
          final visible = cat != null || skill != null;
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: visible ? 110 * scale : -80 * scale,
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
                    horizontal: 24 * scale,
                    vertical: 10 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(30 * scale),
                    border: Border.all(color: Colors.white, width: 3 * scale),
                  ),
                  child: Text(
                    'Cancel selection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20 * scale,
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

  // ---------- TOAST ----------
  Widget _toast(double scale) {
    return ValueListenableBuilder<String?>(
      valueListenable: game.toast,
      builder: (context, msg, _) => AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: msg == null ? 0 : 1,
        child: IgnorePointer(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 120 * scale),
              padding: EdgeInsets.symmetric(
                horizontal: 28 * scale,
                vertical: 14 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(210),
                borderRadius: BorderRadius.circular(16 * scale),
              ),
              child: Text(
                msg ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * scale,
                  fontWeight: FontWeight.w700,
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

