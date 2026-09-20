import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';

class EvolutionOverlay extends StatelessWidget {
  final CatDefenseGame game;

  const EvolutionOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final catData = game.selectedCatData.value;
    if (catData == null) return const SizedBox.shrink();

    final options = catData.evolutionIds
        .map((id) => getCatDataByLevel(id))
        .toList();

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withAlpha(200),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SELECT EVOLUTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: options
                        .map((opt) => _buildOption(context, opt))
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () {
                      game.selectedSlot.value = null;
                      game.draggingCatSlot = null;
                      game.selectedCatData.value = null;
                      game.overlays.remove('Evolution');
                    },
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, CatLevelData opt) {
    final skill = getHeroSkillById(opt.activeSkillId);

    return GestureDetector(
      onTap: () => _applyEvolution(opt),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.orange, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                opt.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Image.asset(
                'Png/Characters/C${opt.level}/Idle/Character${opt.level}-Idle_00.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.pets, size: 80, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 15),
            _buildStat('Tier', '${opt.tier}', Colors.amber),
            _buildStat(
              'Damage',
              opt.damage.toStringAsFixed(0),
              Colors.redAccent,
            ),
            _buildStat(
              'Range',
              opt.range.toStringAsFixed(0),
              Colors.blueAccent,
            ),
            const SizedBox(height: 15),
            if (skill != null) ...[
              const Text(
                'ACTIVE SKILL:',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                skill.name,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                skill.description,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
            ],
            if (opt.synergyTags.isNotEmpty) ...[
              const Text(
                'SYNERGY:',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Wrap(
                spacing: 5,
                children: opt.synergyTags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade800,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'EVOLVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _applyEvolution(CatLevelData choice) {
    final targetSlot = game.selectedSlot.value;
    final sourceSlot = game.draggingCatSlot;

    if (targetSlot != null) {
      // Remove both cats involved in merge
      targetSlot.residentCat?.removeFromParent();
      targetSlot.residentCat = null;
      targetSlot.isOccupied = false;

      if (sourceSlot != null && sourceSlot != targetSlot) {
        sourceSlot.residentCat?.removeFromParent();
        sourceSlot.residentCat = null;
        sourceSlot.isOccupied = false;
      }

      // Place the new evolved cat
      targetSlot.placeFromHud(choice);
      game.gainEnergy(10); // Reward for merging
      game.showToast('Merged into ${choice.name}!');
    }

    // Reset game state
    game.selectedSlot.value = null;
    game.draggingCatSlot = null;
    game.selectedCatData.value = null;
    game.overlays.remove('Evolution');
  }
}
