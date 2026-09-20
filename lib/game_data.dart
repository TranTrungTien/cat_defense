enum CatBranch { gunner, bomber, support, control, melee }

enum SynergyTag {
  pistol,
  rifle,
  explosive,
  electric,
  melee,
  rapid,
  precision,
  control,
  support,
  military,
  scientist,
  street,
}

enum EnemyRole {
  walker,
  runner,
  tank,
  shield,
  ranged,
  support,
  infiltrator,
  siege,
}

enum SkillCastType { instant, lane, position }

class CatLevelData {
  final int level;
  final String id;
  final String name;
  final int tier;
  final CatBranch branch;
  final List<int> evolutionIds;
  final String activeSkillId;
  final List<SynergyTag> synergyTags;
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
    this.id = '',
    this.name = '',
    this.tier = 1,
    this.branch = CatBranch.gunner,
    this.evolutionIds = const [],
    this.activeSkillId = '',
    this.synergyTags = const [],
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

CatLevelData _c(
  int lv,
  String id,
  String name,
  int tier,
  CatBranch br,
  List<int> evo,
  String skill,
  List<SynergyTag> tags, {
  int cost = 80,
  double dmg = 14,
  double range = 720,
  double iv = 1.05,
}) {
  return CatLevelData(
    level: lv,
    id: id,
    name: name,
    tier: tier,
    branch: br,
    evolutionIds: evo,
    activeSkillId: skill,
    synergyTags: tags,
    cost: cost,
    damage: dmg,
    range: range,
    attackInterval: iv,
    atlasPath: 'assets/Json_Atlas/Cat_Characters/Cat$lv/Character$lv.atlas',
    jsonPath: 'assets/Json_Atlas/Cat_Characters/Cat$lv/Character$lv.json',
    visualOffsetY: -10.0,
    muzzleX: 15.0,
    muzzleY: -20.0,
    bulletSpritePath: 'assets/Png/Bullets/Artboard_1.png',
  );
}

final List<CatLevelData> catLevels = [
  _c(
    1,
    'gunner',
    'Gunner',
    1,
    CatBranch.gunner,
    [2, 3],
    'bullet_storm',
    [SynergyTag.pistol, SynergyTag.rapid, SynergyTag.military],
  ),
  _c(
    2,
    'rapid',
    'Rapid Cat',
    2,
    CatBranch.gunner,
    [4, 5],
    'bullet_storm',
    [SynergyTag.pistol, SynergyTag.rapid, SynergyTag.military],
    cost: 160,
    dmg: 16,
    iv: 0.7,
  ),
  _c(
    3,
    'marksman',
    'Marksman',
    2,
    CatBranch.gunner,
    [6, 7],
    'deadeye',
    [SynergyTag.rifle, SynergyTag.precision, SynergyTag.military],
    cost: 160,
    dmg: 28,
    range: 980,
    iv: 1.35,
  ),
  _c(
    4,
    'gatling',
    'Gatling',
    3,
    CatBranch.gunner,
    [],
    'bullet_storm',
    [SynergyTag.pistol, SynergyTag.rapid, SynergyTag.military],
    cost: 320,
    dmg: 18,
    iv: 0.42,
  ),
  _c(
    5,
    'electric',
    'Electric Gunner',
    3,
    CatBranch.gunner,
    [],
    'chain_lightning',
    [SynergyTag.electric, SynergyTag.scientist],
    cost: 320,
    dmg: 22,
    iv: 0.85,
  ),
  _c(
    6,
    'sniper',
    'Sniper',
    3,
    CatBranch.gunner,
    [],
    'deadeye',
    [SynergyTag.rifle, SynergyTag.precision, SynergyTag.military],
    cost: 320,
    dmg: 48,
    range: 1200,
    iv: 1.6,
  ),
  _c(
    7,
    'railgun',
    'Railgun',
    3,
    CatBranch.gunner,
    [],
    'deadeye',
    [SynergyTag.rifle, SynergyTag.precision],
    cost: 320,
    dmg: 62,
    range: 1300,
    iv: 1.9,
  ),
  _c(
    8,
    'bomber',
    'Bomber',
    1,
    CatBranch.bomber,
    [9, 10],
    'cluster_bomb',
    [SynergyTag.explosive, SynergyTag.military],
    dmg: 22,
    range: 560,
    iv: 1.4,
  ),
  _c(
    9,
    'grenadier',
    'Grenadier',
    2,
    CatBranch.bomber,
    [],
    'cluster_bomb',
    [SynergyTag.explosive],
    cost: 160,
    dmg: 32,
    range: 620,
    iv: 1.25,
  ),
  _c(
    10,
    'rocket',
    'Rocket Cat',
    2,
    CatBranch.bomber,
    [],
    'cluster_bomb',
    [SynergyTag.explosive, SynergyTag.military],
    cost: 160,
    dmg: 40,
    range: 800,
    iv: 1.5,
  ),
  _c(
    11,
    'support',
    'Support',
    1,
    CatBranch.support,
    [12, 13],
    'repair',
    [SynergyTag.support, SynergyTag.street],
    dmg: 6,
    range: 480,
    iv: 1.2,
  ),
  _c(
    12,
    'engineer',
    'Engineer',
    2,
    CatBranch.support,
    [],
    'turret',
    [SynergyTag.support],
    cost: 160,
    dmg: 10,
    range: 520,
  ),
  _c(
    13,
    'medic',
    'Medic',
    2,
    CatBranch.support,
    [],
    'repair',
    [SynergyTag.support, SynergyTag.street],
    cost: 160,
    dmg: 4,
    range: 400,
    iv: 1.1,
  ),
  _c(
    14,
    'ice',
    'Ice Cat',
    1,
    CatBranch.control,
    [],
    'absolute_zero',
    [SynergyTag.control, SynergyTag.scientist],
    dmg: 10,
    range: 640,
    iv: 1.15,
  ),
  _c(
    15,
    'boxer',
    'Boxer',
    1,
    CatBranch.melee,
    [],
    'street_charge',
    [SynergyTag.melee, SynergyTag.street],
    dmg: 26,
    range: 220,
    iv: 0.9,
  ),
];

CatLevelData getCatDataByLevel(int level) {
  final index = (level - 1).clamp(0, catLevels.length - 1);
  return catLevels[index];
}

List<CatLevelData> get summonPool =>
    catLevels.where((c) => c.tier == 1).toList();

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
  final double attackDamage;

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
    this.attackDamage = 10,
  });

  double get hp => maxHp;
  int get reward => coinReward;
}

final List<EnemyTypeData> enemyRegistry = [
  ...List.generate(8, (i) {
    final idx = i + 1;
    const roles = [
      EnemyRole.walker,
      EnemyRole.runner,
      EnemyRole.tank,
      EnemyRole.shield,
      EnemyRole.ranged,
      EnemyRole.support,
      EnemyRole.infiltrator,
      EnemyRole.siege,
    ];
    const atk = [8.0, 6.0, 14.0, 8.0, 12.0, 0.0, 16.0, 40.0];
    return EnemyTypeData(
      id: 'reg_$idx',
      name: 'Regular Enemy $idx',
      maxHp: (i == 2 || i == 3) ? 90.0 + (i * 40.0) : 40.0 + (i * 30.0),
      speed: i == 1 ? 90.0 : (i == 2 ? 28.0 : 45.0 + (i * 4.0)),
      coinReward: 10 + (i * 4),
      isBoss: false,
      atlasPath: 'assets/Json_Atlas/Enemies/Enemy_Reg_$idx/Enemy.atlas',
      jsonPath: 'assets/Json_Atlas/Enemies/Enemy_Reg_$idx/Enemy.json',
      scale: 0.85,
      role: roles[i],
      attackDamage: atk[i],
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

class HeroSkill {
  final String id;
  final String name;
  final String description;
  final double cooldown;
  final int energyCost;
  final SkillCastType castType;

  const HeroSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.cooldown,
    required this.energyCost,
    this.castType = SkillCastType.instant,
  });
}

const List<HeroSkill> heroSkillRegistry = [
  HeroSkill(
    id: 'bullet_storm',
    name: 'Bullet Storm',
    description: 'Fire rate x2.2 trong 5s',
    cooldown: 22,
    energyCost: 25,
  ),
  HeroSkill(
    id: 'deadeye',
    name: 'Deadeye',
    description: 'Bắn enemy HP cao nhất trên lane',
    cooldown: 24,
    energyCost: 30,
    castType: SkillCastType.lane,
  ),
  HeroSkill(
    id: 'cluster_bomb',
    name: 'Cluster Bomb',
    description: 'Nổ cụm trên lane',
    cooldown: 20,
    energyCost: 35,
    castType: SkillCastType.position,
  ),
  HeroSkill(
    id: 'chain_lightning',
    name: 'Chain Lightning',
    description: 'Sét lan 4 mục tiêu',
    cooldown: 18,
    energyCost: 30,
  ),
  HeroSkill(
    id: 'repair',
    name: 'Emergency Repair',
    description: 'Hồi tường',
    cooldown: 32,
    energyCost: 25,
  ),
  HeroSkill(
    id: 'turret',
    name: 'Auto Turret',
    description: 'Nổ/turret tạm trên lane',
    cooldown: 28,
    energyCost: 35,
  ),
  HeroSkill(
    id: 'absolute_zero',
    name: 'Absolute Zero',
    description: 'Đóng băng 1 lane 3s',
    cooldown: 26,
    energyCost: 30,
    castType: SkillCastType.lane,
  ),
  HeroSkill(
    id: 'street_charge',
    name: 'Street Charge',
    description: 'Đẩy lùi cả lane',
    cooldown: 16,
    energyCost: 20,
    castType: SkillCastType.lane,
  ),
];

HeroSkill? getHeroSkillById(String id) {
  if (id.isEmpty) return null;
  for (final s in heroSkillRegistry) {
    if (s.id == id) return s;
  }
  return null;
}

class PerkData {
  final String id;
  final String name;
  final String description;
  const PerkData(this.id, this.name, this.description);
}

const List<PerkData> perkRegistry = [
  PerkData('fire_rate', 'Rapid Fire', '+18% fire rate'),
  PerkData('overkill', 'Overkill', 'Damage dư chuyển sang mục tiêu tiếp'),
  PerkData('wall_hp', 'Fortify', '+25% max HP tường'),
  PerkData('summon_discount', 'Street Deal', 'Summon -20% cost'),
  PerkData('close_combat', 'Close Combat', '+35% dmg khi zombie gần tường'),
  PerkData('efficient_cast', 'Efficient Casting', 'Combo hoàn 10 energy'),
  PerkData('chain_reaction', 'Chain Reaction', 'Bomb carrier nổ mạnh hơn'),
  PerkData('desperate', 'Desperate Defense', 'Fire rate tăng khi tường thấp'),
];
