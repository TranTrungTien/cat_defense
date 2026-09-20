import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/managers/community_manager.dart';
import 'package:cat_defense/screens/leaderboard_screen.dart';

class ExtraTab extends StatelessWidget {
  const ExtraTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;
    final skills = [
      {
        'id': 'spikes',
        'name': 'Spikes',
        'icon': Icons.landscape,
        'maxLevel': 5,
        'basePrice': 25,
      },
      {
        'id': 'tnt',
        'name': 'TNT',
        'icon': Icons.brightness_high,
        'maxLevel': 5,
        'basePrice': 50,
      },
    ];

    final baseUpgrades = [
      {
        'id': 'laboratory',
        'name': 'Laboratory',
        'icon': Icons.science,
        'description': 'Tăng tốc độ hồi Team Energy.',
      },
      {
        'id': 'armory',
        'name': 'Armory',
        'icon': Icons.shield,
        'description': 'Tăng Coin khởi đầu mỗi Run.',
      },
      {
        'id': 'workshop',
        'name': 'Workshop',
        'icon': Icons.build,
        'description': 'Giảm chi phí Energy của Skill.',
      },
    ];

    return ListenableBuilder(
      listenable: playerManager,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('GLOBAL LEADERBOARD', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'BASE UPGRADES',
                    style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),

              ...baseUpgrades.map((upgrade) {
                final currentLevel = playerManager.data.baseUpgrades[upgrade['id']] ?? 0;
                final price = 10 * (currentLevel + 1);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Icon(upgrade['icon'] as IconData, size: 40, color: Colors.orange),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(upgrade['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(upgrade['description'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('Level $currentLevel', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => playerManager.upgradeBase(upgrade['id'] as String, price),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.diamond, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text('$price', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'TRAP UPGRADES',
                    style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),

              ...skills.map((skill) {

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'COMMUNITY EVENTS',
                    style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),

              ListenableBuilder(
                listenable: CommunityManager.instance,
                builder: (context, _) {
                  final manager = CommunityManager.instance;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF8E24AA), Color(0xFF5E35B1)]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.purple.withAlpha(50), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('GLOBAL BOSS: ${manager.globalBossName}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const Text('LIVE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(value: manager.globalBossHpPercent, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.greenAccent), minHeight: 12),
                        const SizedBox(height: 8),
                        Text('SERVER HP: ${(manager.globalBossHpPercent * 100).toInt()}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            manager.joinAssault(100);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Damage dealt to Global Boss!')));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
                          child: const Text('JOIN ASSAULT', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
