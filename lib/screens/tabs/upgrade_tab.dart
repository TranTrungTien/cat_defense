import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';

class UpgradeTab extends StatelessWidget {
  const UpgradeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;
    return ListenableBuilder(
      listenable: playerManager,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 15,
          itemBuilder: (context, index) {
            final catId = 'Cat${index + 1}';
            final catData = playerManager.data.cats[catId]!;
            final price = catData.isUnlocked
                ? (catData.level * 50)
                : ((index + 1) * 100);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white..withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: catData.isUnlocked ? Colors.amber : Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.pets, color: Colors.white54),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${catData.level}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Expanded(
                              child: Container(
                                height: 10,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      i <
                                          (catData.level % 5 == 0
                                              ? 5
                                              : catData.level % 5)
                                      ? Colors.blue
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
                  GestureDetector(
                    onTap: () async {
                      if (catData.isUnlocked) {
                        await playerManager.upgradeCatWithGems(catId, price);
                      } else {
                        await playerManager.unlockCatWithGems(catId, price);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
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
