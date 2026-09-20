class CatData {
  final String id;
  int level;
  bool isUnlocked;

  CatData({required this.id, this.level = 1, this.isUnlocked = false});

  Map<String, dynamic> toJson() => {
    'id': id,
    'level': level,
    'isUnlocked': isUnlocked,
  };

  factory CatData.fromJson(Map<String, dynamic> json) => CatData(
    id: json['id'],
    level: json['level'] ?? 1,
    isUnlocked: json['isUnlocked'] ?? false,
  );
}

class RunHistoryEntry {
  final DateTime date;
  final int waveReached;
  final int biomeReached;
  final List<String> perks;

  RunHistoryEntry({
    required this.date,
    required this.waveReached,
    required this.biomeReached,
    required this.perks,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'waveReached': waveReached,
    'biomeReached': biomeReached,
    'perks': perks,
  };

  factory RunHistoryEntry.fromJson(Map<String, dynamic> json) => RunHistoryEntry(
    date: DateTime.parse(json['date']),
    waveReached: json['waveReached'] ?? 0,
    biomeReached: json['biomeReached'] ?? 1,
    perks: List<String>.from(json['perks'] ?? []),
  );
}

class PlayerData {
  int coins;
  int gems;
  int unlockedLevel;
  Map<String, CatData> cats;
  Map<String, int> skillLevels;
  List<String> selectedCats;

  // Meta Progression
  int bestWave;
  List<RunHistoryEntry> runHistory;
  Map<String, int> baseUpgrades;

  PlayerData({
    this.coins = 1000,
    this.gems = 10,
    this.unlockedLevel = 1,
    required this.cats,
    this.skillLevels = const {'spikes': 0, 'tnt': 0},
    required this.selectedCats,
    this.bestWave = 0,
    this.runHistory = const [],
    this.baseUpgrades = const {'laboratory': 0, 'armory': 0, 'workshop': 0},
  });
}
