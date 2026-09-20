enum CatBranch { base, gunner, marksman, explosive, support, fighter, control, scientist, survivor }

enum SynergyTag { military, scientist, street, survivor, explosive, energy, rapid, precision, control, support }

class CatLevelData {
  final int id;
  final int tier;
  final String name;
  final CatBranch branch;
  final int cost;
  final double damage;
  final double range;
  final double attackInterval;
  final String atlasPath;
  final String jsonPath;
  final List<int> evolutionIds;
  final String animationName;

  final double visualOffsetX;
  final double visualOffsetY;
  final double muzzleX;
  final double muzzleY;
  final String bulletSpritePath;

  // New fields for Merge Cats: Endless Outpost
  final String? activeSkillId;
  final int energyCost;
  final double skillCooldown;
  final List<SynergyTag> synergyTags;

  const CatLevelData({
    required this.id,
    required this.tier,
    required this.name,
    required this.branch,
    required this.cost,
    required this.damage,
    required this.range,
    required this.attackInterval,
    required this.atlasPath,
    required this.jsonPath,
    this.evolutionIds = const [],
    this.animationName = 'idle',
    this.visualOffsetX = 0.0,
    this.visualOffsetY = 0.0,
    this.muzzleX = 15.0,
    this.muzzleY = -20.0,
    this.bulletSpritePath = '',
    this.activeSkillId,
    this.energyCost = 25,
    this.skillCooldown = 20.0,
    this.synergyTags = const [],
  });

  // Level hien tai (alias cho tier de tuong thich code cu)
  int get level => id;
  int get upgradeCost => cost;
  double get fireRate => attackInterval;
  String get bulletSprite => bulletSpritePath.isNotEmpty
      ? bulletSpritePath
      : 'assets/Png/Bullets/Artboard_1.png';
}

final List<CatLevelData> catLevels = [
  // TIER 1 - BASE
  CatLevelData(
    id: 1,
    tier: 1,
    name: 'Pistol Cat',
    branch: CatBranch.base,
    cost: 50,
    damage: 15,
    range: 200,
    attackInterval: 1.0,
    evolutionIds: [2, 8], // Evolves to Rapid Cat or Bomber Cat
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat1/Character1.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat1/Character1.json',
    activeSkillId: 'bullet_storm',
    synergyTags: [SynergyTag.street],
  ),

  // TIER 2 - GUNNER BRANCH
  CatLevelData(
    id: 2,
    tier: 2,
    name: 'Rapid Cat',
    branch: CatBranch.gunner,
    cost: 120,
    damage: 12,
    range: 180,
    attackInterval: 0.6,
    evolutionIds: [3, 4], // Evolves to Gatling or Marksman
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat2/Character2.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat2/Character2.json',
    activeSkillId: 'bullet_storm',
    synergyTags: [SynergyTag.military, SynergyTag.rapid],
  ),

  // TIER 3 - GUNNER SPECIALIZED
  CatLevelData(
    id: 3,
    tier: 3,
    name: 'Gatling Cat',
    branch: CatBranch.gunner,
    cost: 250,
    damage: 10,
    range: 220,
    attackInterval: 0.2,
    evolutionIds: [5, 6], // Evolves to Elite Gatling or Electric Gunner
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat3/Character3.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat3/Character3.json',
    activeSkillId: 'overheat',
    synergyTags: [SynergyTag.military, SynergyTag.rapid],
  ),
  CatLevelData(
    id: 4,
    tier: 3,
    name: 'Marksman Cat',
    branch: CatBranch.gunner,
    cost: 250,
    damage: 50,
    range: 400,
    attackInterval: 1.5,
    evolutionIds: [7, 15], // Evolves to Sniper or Railgun
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat4/Character4.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat4/Character4.json',
    activeSkillId: 'deadeye',
    synergyTags: [SynergyTag.military, SynergyTag.precision],
  ),

  // TIER 4 - GUNNER FINAL
  CatLevelData(
    id: 5,
    tier: 4,
    name: 'Elite Gatling',
    branch: CatBranch.gunner,
    cost: 500,
    damage: 15,
    range: 250,
    attackInterval: 0.15,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat5/Character5.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat5/Character5.json',
    activeSkillId: 'overheat',
    synergyTags: [SynergyTag.military, SynergyTag.rapid],
  ),
  CatLevelData(
    id: 6,
    tier: 4,
    name: 'Electric Gunner',
    branch: CatBranch.gunner,
    cost: 550,
    damage: 25,
    range: 200,
    attackInterval: 0.5,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat6/Character6.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat6/Character6.json',
    activeSkillId: 'chain_lightning',
    synergyTags: [SynergyTag.scientist, SynergyTag.energy],
  ),
  CatLevelData(
    id: 7,
    tier: 4,
    name: 'Sniper Cat',
    branch: CatBranch.gunner,
    cost: 600,
    damage: 150,
    range: 600,
    attackInterval: 3.0,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat7/Character7.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat7/Character7.json',
    activeSkillId: 'deadeye',
    synergyTags: [SynergyTag.military, SynergyTag.precision],
  ),
  CatLevelData(
    id: 15,
    tier: 4,
    name: 'Railgun Cat',
    branch: CatBranch.gunner,
    cost: 800,
    damage: 500,
    range: 800,
    attackInterval: 5.0,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat15/Character15.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat15/Character15.json',
    activeSkillId: 'deadeye',
    synergyTags: [SynergyTag.military, SynergyTag.precision],
  ),

  // TIER 2 - EXPLOSIVE BRANCH
  CatLevelData(
    id: 8,
    tier: 2,
    name: 'Bomber Cat',
    branch: CatBranch.explosive,
    cost: 150,
    damage: 40,
    range: 150,
    attackInterval: 2.0,
    evolutionIds: [9, 10], // Evolves to Grenadier or Rocket Cat
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat8/Character8.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat8/Character8.json',
    activeSkillId: 'cluster_bomb',
    synergyTags: [SynergyTag.street, SynergyTag.explosive],
  ),

  // TIER 3 - EXPLOSIVE SPECIALIZED
  CatLevelData(
    id: 9,
    tier: 3,
    name: 'Grenadier',
    branch: CatBranch.explosive,
    cost: 280,
    damage: 80,
    range: 160,
    attackInterval: 1.8,
    evolutionIds: [11, 12], // Evolves to Cluster or Fire Bomber
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat9/Character9.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat9/Character9.json',
    activeSkillId: 'cluster_bomb',
    synergyTags: [SynergyTag.military, SynergyTag.explosive],
  ),
  CatLevelData(
    id: 10,
    tier: 3,
    name: 'Rocket Cat',
    branch: CatBranch.explosive,
    cost: 300,
    damage: 120,
    range: 300,
    attackInterval: 2.5,
    evolutionIds: [13, 14], // Evolves to Homing or Heavy Rocket
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat10/Character10.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat10/Character10.json',
    activeSkillId: 'homing_rocket',
    synergyTags: [SynergyTag.military, SynergyTag.explosive],
  ),

  // TIER 4 - EXPLOSIVE FINAL
  CatLevelData(
    id: 11,
    tier: 4,
    name: 'Cluster Bomber',
    branch: CatBranch.explosive,
    cost: 650,
    damage: 100,
    range: 180,
    attackInterval: 2.0,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat11/Character11.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat11/Character11.json',
    activeSkillId: 'cluster_bomb',
    synergyTags: [SynergyTag.military, SynergyTag.explosive],
  ),
  CatLevelData(
    id: 12,
    tier: 4,
    name: 'Fire Bomber',
    branch: CatBranch.explosive,
    cost: 650,
    damage: 90,
    range: 180,
    attackInterval: 2.0,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat12/Character12.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat12/Character12.json',
    activeSkillId: 'fire_bomb',
    synergyTags: [SynergyTag.scientist, SynergyTag.explosive],
  ),
  CatLevelData(
    id: 13,
    tier: 4,
    name: 'Homing Rocket',
    branch: CatBranch.explosive,
    cost: 700,
    damage: 200,
    range: 400,
    attackInterval: 3.5,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat13/Character13.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat13/Character13.json',
    activeSkillId: 'homing_rocket',
    synergyTags: [SynergyTag.military, SynergyTag.explosive],
  ),
  CatLevelData(
    id: 14,
    tier: 4,
    name: 'Heavy Rocket',
    branch: CatBranch.explosive,
    cost: 750,
    damage: 350,
    range: 350,
    attackInterval: 4.0,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat14/Character14.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat14/Character14.json',
    activeSkillId: 'heavy_rocket',
    synergyTags: [SynergyTag.military, SynergyTag.explosive],
  ),
];

CatLevelData getCatDataByLevel(int level) {
  return catLevels.firstWhere(
    (data) => data.id == level,
    orElse: () => catLevels.first,
  );
}

enum EnemyRole { walker, tank, ranged, disruptor, support, infiltrator, siege }

class HeroSkillData {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final int energyCost;
  final double cooldown;
  final double? damage;
  final double? radius;
  final double? duration;

  const HeroSkillData({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.energyCost,
    required this.cooldown,
    this.damage,
    this.radius,
    this.duration,
  });
}

final List<HeroSkillData> heroSkillRegistry = [
  const HeroSkillData(
    id: 'bullet_storm',
    name: 'Bullet Storm',
    description: 'Tăng mạnh tốc độ bắn trong 5 giây.',
    iconPath: 'assets/Png/Ui/Skill_BulletStorm.png',
    energyCost: 25,
    cooldown: 25.0,
    duration: 5.0,
  ),
  const HeroSkillData(
    id: 'cluster_bomb',
    name: 'Cluster Bomb',
    description: 'Tạo vụ nổ lớn chia thành nhiều mảnh nhỏ.',
    iconPath: 'assets/Png/Ui/Skill_ClusterBomb.png',
    energyCost: 40,
    cooldown: 30.0,
    damage: 100.0,
    radius: 120.0,
  ),
  const HeroSkillData(
    id: 'deadeye',
    name: 'Deadeye',
    description: 'Nhắm enemy có HP cao nhất, gây damage cực lớn.',
    iconPath: 'assets/Png/Ui/Skill_Deadeye.png',
    energyCost: 35,
    cooldown: 24.0,
    damage: 500.0,
  ),
  const HeroSkillData(
    id: 'overheat',
    name: 'Overheat',
    description: 'Tăng tốc bắn cực hạn, đạn xuyên mục tiêu.',
    iconPath: 'assets/Png/Ui/Skill_Overheat.png',
    energyCost: 50,
    cooldown: 40.0,
    duration: 6.0,
  ),
  const HeroSkillData(
    id: 'chain_lightning',
    name: 'Chain Lightning',
    description: 'Sét lan qua nhiều mục tiêu, gây shock.',
    iconPath: 'assets/Png/Ui/Skill_ChainLightning.png',
    energyCost: 30,
    cooldown: 20.0,
    damage: 40.0,
  ),
  const HeroSkillData(
    id: 'homing_rocket',
    name: 'Homing Rocket',
    description: 'Bắn rocket tự đuổi mục tiêu.',
    iconPath: 'assets/Png/Ui/Skill_HomingRocket.png',
    energyCost: 30,
    cooldown: 25.0,
    damage: 200.0,
  ),
  const HeroSkillData(
    id: 'fire_bomb',
    name: 'Fire Bomb',
    description: 'Đốt cháy vùng mục tiêu.',
    iconPath: 'assets/Png/Ui/Skill_FireBomb.png',
    energyCost: 35,
    cooldown: 30.0,
    damage: 15.0,
    duration: 4.0,
    radius: 100.0,
  ),
  const HeroSkillData(
    id: 'blizzard',
    name: 'Blizzard',
    description: 'Đóng băng toàn bộ chiến trường.',
    iconPath: 'assets/Png/Ui/Skill_Blizzard.png',
    energyCost: 60,
    cooldown: 50.0,
    duration: 3.0,
  ),
  const HeroSkillData(
    id: 'tesla_storm',
    name: 'Tesla Storm',
    description: 'Bão điện gây shock toàn bộ zombie.',
    iconPath: 'assets/Png/Ui/Skill_TeslaStorm.png',
    energyCost: 65,
    cooldown: 55.0,
    damage: 60.0,
  ),
];

HeroSkillData? getHeroSkillById(String? id) {
  if (id == null) return null;
  return heroSkillRegistry.firstWhere(
    (s) => s.id == id,
    orElse: () => heroSkillRegistry.first,
  );
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
  final EnemyRole role;
  final List<String> skills;

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
    this.role = EnemyRole.walker,
    this.skills = const [],
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
      role: i == 3 ? EnemyRole.siege : (i % 3 == 0 ? EnemyRole.walker : (i % 3 == 1 ? EnemyRole.tank : EnemyRole.ranged)),
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
      role: EnemyRole.tank,
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

class PerkData {
  final String id;
  final String name;
  final String description;
  final String iconPath;

  const PerkData({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
  });
}

final List<PerkData> perkRegistry = [
  const PerkData(
    id: 'rapid_fire',
    name: 'Rapid Fire',
    description: 'Tăng 15% tốc độ bắn cho toàn đội.',
    iconPath: 'assets/Png/Ui/Perk_RapidFire.png',
  ),
  const PerkData(
    id: 'heavy_bullets',
    name: 'Heavy Bullets',
    description: 'Tăng 20% sát thương đạn.',
    iconPath: 'assets/Png/Ui/Perk_HeavyBullets.png',
  ),
  const PerkData(
    id: 'emergency_repair',
    name: 'Emergency Repair',
    description: 'Tường tự hồi 5% HP mỗi wave.',
    iconPath: 'assets/Png/Ui/Perk_Repair.png',
  ),
  const PerkData(
    id: 'bounty_hunter',
    name: 'Bounty Hunter',
    description: 'Nhận thêm 10% coin mỗi khi hạ zombie.',
    iconPath: 'assets/Png/Ui/Perk_Bounty.png',
  ),
  const PerkData(
    id: 'chain_reaction',
    name: 'Chain Reaction',
    description: 'Zombie chết nổ gây sát thương xung quanh.',
    iconPath: 'assets/Png/Ui/Perk_Chain.png',
  ),
];

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
