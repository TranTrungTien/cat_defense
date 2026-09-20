import 'package:flutter/material.dart';
import 'package:cat_defense/screens/level_map_screen.dart';
import 'package:cat_defense/screens/roguelite_map_screen.dart';
import 'package:cat_defense/managers/run_manager.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'CAT DEFENSE: OUTPOST',
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBtn(
                context,
                'DAILY CHALLENGE',
                Colors.deepPurple,
                () {
                  final now = DateTime.now();
                  final dailySeed = now.year * 10000 + now.month * 100 + now.day;
                  RunManager.instance.startNewRun(seed: dailySeed);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RogueliteMapScreen()));
                }
              ),
              const SizedBox(width: 20),
              _buildBtn(
                context,
                'ROGUE RUN',
                Colors.redAccent,
                () {
                  RunManager.instance.startNewRun();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RogueliteMapScreen()));
                }
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildBtn(
            context,
            'CAMPAIGN MAP',
            Colors.orange,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelMapScreen()))
          ),
          const SizedBox(height: 40),
          _buildMissionSection(),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    final missions = [
      {'title': 'Wave Warrior', 'desc': 'Reach Wave 30', 'progress': 0.4},
      {'title': 'Skill Master', 'desc': 'Interrupt 10 skills', 'progress': 0.7},
      {'title': 'Global Assault', 'desc': 'Damage Global Boss', 'progress': 1.0},
    ];

    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          const Text('ACTIVE MISSIONS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ...missions.map((m) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    Text('${((m['progress'] as double) * 100).toInt()}%', style: const TextStyle(color: Colors.amber, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: m['progress'] as double, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(Colors.amber)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBtn(BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
