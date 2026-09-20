import 'package:flutter/material.dart';
import 'package:cat_defense/managers/run_manager.dart';
import 'package:cat_defense/screens/game_screen.dart';

class RogueliteMapScreen extends StatefulWidget {
  const RogueliteMapScreen({super.key});

  @override
  State<RogueliteMapScreen> createState() => _RogueliteMapScreenState();
}

class _RogueliteMapScreenState extends State<RogueliteMapScreen> {
  @override
  Widget build(BuildContext context) {
    final run = RunManager.instance;
    final layers = <int, List<RunNode>>{};
    for (var node in run.map) {
      layers.putIfAbsent(node.depth, () => []).add(node);
    }

    final maxDepth = layers.keys.isEmpty
        ? 0
        : layers.keys.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              reverse: true, // Start from bottom
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(maxDepth + 1, (d) {
                    final layerNodes = layers[d] ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: layerNodes
                            .map((node) => _buildNode(context, node))
                            .toList(),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'BIOME ${run.currentBiome}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode(BuildContext context, RunNode node) {
    final isAccessible = node.isAccessible;
    final isCompleted = node.isCompleted;

    Color color = Colors.grey.shade800;
    IconData icon = Icons.help;

    switch (node.type) {
      case NodeType.battle:
        color = Colors.red.shade900;
        icon = Icons.security;
        break;
      case NodeType.elite:
        color = Colors.purple.shade900;
        icon = Icons.warning;
        break;
      case NodeType.shop:
        color = Colors.amber.shade900;
        icon = Icons.shopping_cart;
        break;
      case NodeType.mystery:
        color = Colors.blueGrey.shade800;
        icon = Icons.question_mark;
        break;
      case NodeType.rescue:
        color = Colors.green.shade900;
        icon = Icons.person_add;
        break;
      case NodeType.workshop:
        color = Colors.blue.shade900;
        icon = Icons.build;
        break;
      case NodeType.boss:
        color = Colors.black;
        icon = Icons.dangerous;
        break;
    }

    if (isCompleted) color = Colors.grey.shade600;
    if (!isAccessible && !isCompleted) color = color.withAlpha(50);

    return GestureDetector(
      onTap: isAccessible ? () => _startNode(context, node) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isAccessible ? Colors.white : Colors.white24,
            width: isAccessible ? 3 : 1,
          ),
          boxShadow: isAccessible
              ? [
                  BoxShadow(
                    color: Colors.white.withAlpha(50),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isAccessible ? Colors.white : Colors.white54,
          size: 40,
        ),
      ),
    );
  }

  void _startNode(BuildContext context, RunNode node) {
    // In a real roguelite, different node types trigger different screens.
    // For now, most trigger Battle (GameScreen).
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GameScreen(roguelite: true)),
    ).then((result) {
      if (result == true) {
        setState(() {
          RunManager.instance.completeNode(node.id);
        });
      }
    });
  }
}
