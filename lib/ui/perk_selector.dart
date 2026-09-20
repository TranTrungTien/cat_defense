import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/managers/run_manager.dart';

class PerkSelector extends StatelessWidget {
  final CatDefenseGame game;
  const PerkSelector({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final perks = List<PerkData>.from(perkRegistry)..shuffle(random);
    final selection = perks.take(3).toList();

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withAlpha(200),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'CHOOSE A PERK',
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: selection.map((perk) => _buildPerkCard(context, perk)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerkCard(BuildContext context, PerkData perk) {
    return GestureDetector(
      onTap: () {
        RunManager.instance.activePerks.add(perk.id);
        game.overlays.remove('PerkSelector');
        game.resumeEngine();
        game.showToast('Perk Acquired: ${perk.name}');
      },
      child: Container(
        width: 240,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.cyanAccent.withAlpha(30), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              perk.name,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              perk.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
