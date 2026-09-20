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
            'MERGE CATS DEFENDER',
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              RunManager.instance.startNewRun();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RogueliteMapScreen()),
              );
            },
            child: const Text(
              'TAP TO PLAY',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
