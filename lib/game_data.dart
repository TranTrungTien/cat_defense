class CatLevelData {
  final int level;
  final int cost;
  final double damage;
  final double range;
  final double attackInterval;
  final String atlasPath;
  final String jsonPath;
  final String animationName;

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

  int get upgradeCost => cost;
  double get fireRate => attackInterval;
  String get bulletSprite => bulletSpritePath.isNotEmpty
      ? bulletSpritePath
      : 'assets/Png/Bullets/Artboard_1.png';
}

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

CatLevelData getCatDataByLevel(int level) {
  final index = (level - 1).clamp(0, catLevels.length - 1);
  return catLevels[index];
}

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

  double get hp => maxHp;
  int get reward => coinReward;
}

final List<EnemyTypeData> enemyRegistry = [
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

EnemyTypeData getEnemyById(String id) {
  return enemyRegistry.firstWhere(
    (e) => e.id == id,
    orElse: () => enemyRegistry.first,
  );
}

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

  const WaveData({required this.waveIndex, required this.spawns});
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
          EnemySpawnInfo(
            enemyId: regEnemyId,
            count: 4 + level,
            spawnInterval: 1.2,
          ),
        ],
      ),
      WaveData(
        waveIndex: 2,
        spawns: [
          EnemySpawnInfo(
            enemyId: regEnemyId,
            count: 6 + level,
            spawnInterval: 1.0,
          ),
        ],
      ),
      WaveData(
        waveIndex: 3,
        spawns: [
          EnemySpawnInfo(
            enemyId: regEnemyId,
            count: 8 + level,
            spawnInterval: 0.8,
          ),
          EnemySpawnInfo(enemyId: bossEnemyId, count: 1, spawnInterval: 2.0),
        ],
      ),
    ],
  );
}
