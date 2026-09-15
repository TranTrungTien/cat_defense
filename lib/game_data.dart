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
  1: {'mx': 90, 'my': 6, 'vx': -20, 'vy': -5}, // Meo xam, sung cam gio cao
  2: {'mx': 85, 'my': 6, 'vx': -15, 'vy': -5}, // Meo vang, mu hong
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
