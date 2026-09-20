import 'dart:math';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/components/cat_component.dart';
import 'package:cat_defense/managers/run_manager.dart';

class AIDirector {
  final CatDefenseGame game;
  final Random _random = Random();

  double _intensity = 0.0;

  AIDirector(this.game);

  void update(double dt) {
    // Basic intensity calculation
    // Increases if player is doing well (high coins, high castle HP)
    // Decreases if player is struggling
    double targetIntensity = 0.5;

    if (game.castleHp.value > 0.8) targetIntensity += 0.2;
    if (game.coins.value > 1000) targetIntensity += 0.1;
    if (game.castleHp.value < 0.3) targetIntensity -= 0.3;

    _intensity = _intensity * 0.95 + targetIntensity * 0.05;
  }

  List<EnemySpawnInfo> generateWave(int waveIndex) {
    final List<EnemySpawnInfo> spawns = [];

    // Difficulty scales with waveIndex and intensity
    int baseCount = 5 + (waveIndex * 2);

    // Modifier: Elite Territory
    if (RunManager.instance.activeModifiers.contains('elite_territory')) {
       baseCount = (baseCount * 1.5).toInt();
    }

    int extraCount = (_intensity * 10).toInt();
    int totalCount = baseCount + extraCount;

    // Decide enemy mix based on wave
    final regularEnemies = enemyRegistry.where((e) => !e.isBoss).toList();

    // PRD 33: AI Director reactions
    final cats = game.world.children.whereType<CatComponent>();
    final gunnerCount = cats.where((c) => c.data.branch == CatBranch.gunner).length;
    final marksmanCount = cats.where((c) => c.data.synergyTags.contains(SynergyTag.precision)).length;

    // As waves progress, introduce more specialized roles
    int availableTypes = (waveIndex / 2).floor().clamp(1, regularEnemies.length);

    if (waveIndex % 5 == 0) {
      // Boss wave mix
      spawns.add(EnemySpawnInfo(
        enemyId: _getBossForWave(waveIndex),
        count: 1,
        spawnInterval: 5.0,
      ));
      totalCount = (totalCount * 0.5).toInt();
    }

    // Split total count into different types
    int remaining = totalCount;
    while (remaining > 0) {
      var typeIdx = _random.nextInt(availableTypes);

      // Reactive logic: if player has many gunners, increase tank/shield presence
      if (gunnerCount > 3 && _random.nextDouble() < 0.3) {
        final tanks = regularEnemies.where((e) => e.role == EnemyRole.tank).toList();
        if (tanks.isNotEmpty) {
          final tankId = tanks[_random.nextInt(tanks.length)].id;
          typeIdx = regularEnemies.indexWhere((e) => e.id == tankId);
        }
      }

      // PRD 33: if player relies on single-target damage (Marksman), increase swarm
      if (marksmanCount > 2 && _random.nextDouble() < 0.25) {
        final walkers = regularEnemies.where((e) => e.role == EnemyRole.walker).toList();
        if (walkers.isNotEmpty) {
           final walkerId = walkers[_random.nextInt(walkers.length)].id;
           typeIdx = regularEnemies.indexWhere((e) => e.id == walkerId);
        }
      }

      final count = min(remaining, _random.nextInt(3) + 1);
      spawns.add(EnemySpawnInfo(
        enemyId: regularEnemies[typeIdx].id,
        count: count,
        spawnInterval: 0.5 + _random.nextDouble(),
      ));
      remaining -= count;
    }

    return spawns;
  }

  String _getBossForWave(int waveIndex) {
    final bosses = enemyRegistry.where((e) => e.isBoss).toList();
    int idx = ((waveIndex ~/ 5) - 1) % bosses.length;
    return bosses[idx].id;
  }
}
