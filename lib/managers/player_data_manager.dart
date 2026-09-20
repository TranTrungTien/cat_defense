import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cat_defense/models/player_data.dart';

class PlayerDataManager extends ChangeNotifier {
  static final PlayerDataManager instance = PlayerDataManager._internal();
  PlayerDataManager._internal();

  static const String _storageKey = 'CAT_DEFENSE_PLAYER_DATA_V2';
  late PlayerData _data;

  PlayerData get data => _data;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString(_storageKey);

    if (rawData != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(rawData);
        final catsMap = (json['cats'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, CatData.fromJson(v)),
        );

        _data = PlayerData(
          coins: json['coins'] ?? 1000,
          gems: json['gems'] ?? 100,
          unlockedLevel: json['unlockedLevel'] ?? 1,
          cats: catsMap,
          skillLevels: Map<String, int>.from(
            json['skillLevels'] ?? {'spikes': 0, 'tnt': 0},
          ),
          selectedCats: List<String>.from(json['selectedCats'] ?? ['Cat1']),
          bestWave: json['bestWave'] ?? 0,
          runHistory: (json['runHistory'] as List? ?? [])
              .map((e) => RunHistoryEntry.fromJson(e))
              .toList(),
          baseUpgrades: Map<String, int>.from(
            json['baseUpgrades'] ?? {'laboratory': 0, 'armory': 0, 'workshop': 0},
          ),
        );
        return;
      } catch (e) {
        debugPrint('Error parsing PlayerData: $e');
      }
    }

    final defaultCats = <String, CatData>{};
    for (int i = 1; i <= 15; i++) {
      final id = 'Cat$i';
      defaultCats[id] = CatData(id: id, isUnlocked: i == 1);
    }

    _data = PlayerData(cats: defaultCats, selectedCats: ['Cat1']);
    await saveData();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMap = {
      'coins': _data.coins,
      'gems': _data.gems,
      'unlockedLevel': _data.unlockedLevel,
      'selectedCats': _data.selectedCats,
      'skillLevels': _data.skillLevels,
      'cats': _data.cats.map((k, v) => MapEntry(k, v.toJson())),
      'bestWave': _data.bestWave,
      'runHistory': _data.runHistory.map((e) => e.toJson()).toList(),
      'baseUpgrades': _data.baseUpgrades,
    };
    await prefs.setString(_storageKey, jsonEncode(jsonMap));
    notifyListeners();
  }

  Future<void> addCoins(int amount) async {
    _data.coins += amount;
    await saveData();
  }

  Future<bool> spendCoins(int amount) async {
    if (_data.coins >= amount) {
      _data.coins -= amount;
      await saveData();
      return true;
    }
    return false;
  }

  Future<void> addGems(int amount) async {
    _data.gems += amount;
    await saveData();
  }

  Future<bool> spendGems(int amount) async {
    if (_data.gems >= amount) {
      _data.gems -= amount;
      await saveData();
      return true;
    }
    return false;
  }

  Future<bool> unlockCatWithGems(String catId, int price) async {
    final cat = _data.cats[catId];
    if (cat != null && !cat.isUnlocked && _data.gems >= price) {
      _data.gems -= price;
      cat.isUnlocked = true;
      await saveData();
      return true;
    }
    return false;
  }

  Future<bool> upgradeCatWithGems(String catId, int price) async {
    final cat = _data.cats[catId];
    if (cat != null && cat.isUnlocked && _data.gems >= price) {
      _data.gems -= price;
      cat.level += 1;
      await saveData();
      return true;
    }
    return false;
  }

  Future<bool> upgradeSkillWithGems(
    String skillId,
    int price,
    int maxLevel,
  ) async {
    final currentLevel = _data.skillLevels[skillId] ?? 0;
    if (currentLevel < maxLevel && _data.gems >= price) {
      _data.gems -= price;
      _data.skillLevels[skillId] = currentLevel + 1;
      await saveData();
      return true;
    }
    return false;
  }

  Future<void> recordRun(int wave, int biome, List<String> perks) async {
    if (wave > _data.bestWave) {
      _data.bestWave = wave;
    }
    _data.runHistory.add(RunHistoryEntry(
      date: DateTime.now(),
      waveReached: wave,
      biomeReached: biome,
      perks: perks,
    ));
    // Keep only last 20 runs
    if (_data.runHistory.length > 20) {
      _data.runHistory.removeAt(0);
    }
    await saveData();
  }

  Future<void> upgradeBase(String buildingId, int price) async {
    final current = _data.baseUpgrades[buildingId] ?? 0;
    if (_data.gems >= price) {
      _data.gems -= price;
      _data.baseUpgrades[buildingId] = current + 1;
      await saveData();
    }
  }

  Future<void> completeLevel(int completedLevel) async {
    if (completedLevel == _data.unlockedLevel && _data.unlockedLevel < 15) {
      _data.unlockedLevel++;
      await saveData();
    }
  }
}
