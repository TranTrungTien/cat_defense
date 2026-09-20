import 'package:flutter/material.dart';

import 'package:cat_defense/managers/community_manager.dart';

class LeaderboardEntry {
  final String name;
  final int wave;
  final int rank;

  LeaderboardEntry({
    required this.name,
    required this.wave,
    required this.rank,
  });
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = CommunityManager.instance;

    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        final data = manager.leaderboard
            .map(
              (e) => LeaderboardEntry(
                name: e['name'] as String,
                wave: e['wave'] as int,
                rank: e['rank'] as int,
              ),
            )
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'GLOBAL LEADERBOARD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => _buildEntry(data[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'RANK',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'PLAYER',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'WAVE',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(LeaderboardEntry entry) {
    Color rankColor = Colors.white70;
    if (entry.rank == 1) {
      rankColor = Colors.amber;
    } else if (entry.rank == 2) {
      rankColor = Colors.grey.shade400;
    } else if (entry.rank == 3) {
      rankColor = Colors.brown.shade300;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: entry.rank <= 3
            ? Colors.white.withAlpha(10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                color: rankColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              entry.name,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${entry.wave}',
              style: TextStyle(
                color: rankColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
