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

class PlayerData {
  int coins;
  int gems;
  int unlockedLevel;
  Map<String, CatData> cats;
  Map<String, int> skillLevels;
  List<String> selectedCats;

  PlayerData({
    this.coins = 1000,
    this.gems = 10,
    this.unlockedLevel = 1,
    required this.cats,
    Map<String, int>? skillLevels,
    required this.selectedCats,
  }) : skillLevels = skillLevels ?? {'spikes': 0, 'tnt': 0};
}
