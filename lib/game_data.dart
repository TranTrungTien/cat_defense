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
