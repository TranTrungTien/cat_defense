import 'package:flutter/foundation.dart';

class CommunityManager extends ChangeNotifier {
  static final CommunityManager instance = CommunityManager._internal();
  CommunityManager._internal();

  double globalBossHpPercent = 0.65;
  String globalBossName = 'MECHA-ZOMBIE';

  List<Map<String, dynamic>> leaderboard = [
    {'name': 'CatMaster', 'wave': 152, 'rank': 1},
    {'name': 'MeowDef', 'wave': 145, 'rank': 2},
    {'name': 'ZombieHunter', 'wave': 130, 'rank': 3},
    {'name': 'FluffyWarrior', 'wave': 118, 'rank': 4},
    {'name': 'OutpostCat', 'wave': 95, 'rank': 5},
  ];

  void joinAssault(int damage) {
    // Mock logic: reduce boss HP
    globalBossHpPercent -= 0.001;
    if (globalBossHpPercent < 0) globalBossHpPercent = 0;
    notifyListeners();
  }

  void refreshLeaderboard() {
    // Mock fetch from server
    notifyListeners();
  }
}
