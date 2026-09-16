import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';

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

    return ListenableBuilder(
      listenable: playerManager,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: skills.length,
          itemBuilder: (context, index) {
            final skill = skills[index];
            final currentLevel =
                playerManager.data.skillLevels[skill['id']] ?? 0;
            final price = (skill['basePrice'] as int) * (currentLevel + 1);
            final isMaxed = currentLevel >= (skill['maxLevel'] as int);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMaxed ? Colors.amber : Colors.white24,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    skill['icon'] as IconData,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Level $currentLevel / ${skill['maxLevel']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            skill['maxLevel'] as int,
                            (i) => Expanded(
                              child: Container(
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: i < currentLevel
                                      ? Colors.orange
                                      : Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (!isMaxed)
                    GestureDetector(
                      onTap: () async {
                        await playerManager.upgradeSkillWithGems(
                          skill['id'] as String,
                          price,
                          skill['maxLevel'] as int,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.diamond,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$price',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
