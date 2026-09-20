import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';

class ShopTab extends StatelessWidget {
  const ShopTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;
    final packages = [
      {'name': 'Starter Pack', 'gems': 125, 'price': '\$4.99'},
      {'name': 'Starter Pack', 'gems': 300, 'price': '\$7.99'},
      {'name': 'Starter Pack', 'gems': 650, 'price': '\$9.99'},
      {'name': 'Starter Pack', 'gems': 1000, 'price': '\$11.99'},
      {'name': 'Best Deals!', 'gems': 2600, 'price': '\$14.99'},
      {'name': 'Super Package', 'gems': 5000, 'price': '\$17.99'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final pkg = packages[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                pkg['name'] as String,
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              const Icon(Icons.diamond, color: Colors.greenAccent, size: 40),
              const SizedBox(height: 12),
              Text(
                '${pkg['gems']} Gems',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () async {
                  await playerManager.addGems(pkg['gems'] as int);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Purchased ${pkg['gems']} Gems!')),
                    );
                  }
                },
                child: Text(
                  pkg['price'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
