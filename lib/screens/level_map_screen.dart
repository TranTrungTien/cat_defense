import 'package:flutter/material.dart';
import 'package:cat_defense/config/level_map_layout.dart';
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/screens/game_screen.dart';

class LevelMapScreen extends StatelessWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;

    return Scaffold(
      body: ListenableBuilder(
        listenable: playerManager,
        builder: (context, _) {
          final unlockedLevel = playerManager.data.unlockedLevel;

          return LayoutBuilder(
            builder: (context, constraints) {
              final scaleX = constraints.maxWidth / LevelMapLayout.mapWidth;
              final scaleY = constraints.maxHeight / LevelMapLayout.mapHeight;
              final scale = scaleX < scaleY ? scaleX : scaleY;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: const Color(0xFF5B8C5A)),
                  ),

                  Positioned.fill(
                    child: CustomPaint(painter: MapPathPainter(scale: scale)),
                  ),

                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'LEVEL SELECT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ..._buildLevelNodes(context, scale, unlockedLevel),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildLevelNodes(
    BuildContext context,
    double scale,
    int unlockedLevel,
  ) {
    final List<Widget> widgets = [];

    for (final node in LevelMapLayout.nodes) {
      final isUnlocked = node.level <= unlockedLevel;
      final isCompleted = node.level < unlockedLevel;

      widgets.add(
        Positioned(
          left: (node.position.x - 30) * scale,
          top: (node.position.y - 30) * scale,
          child: GestureDetector(
            onTap: isUnlocked
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GameScreen(level: node.level),
                      ),
                    );
                  }
                : null,
            child: Container(
              width: 60 * scale,
              height: 60 * scale,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (isCompleted ? Colors.amber : Colors.orange)
                    : Colors.grey.shade700,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3 * scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        '${node.level}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24 * scale,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Icon(Icons.lock, color: Colors.white54, size: 24 * scale),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

class MapPathPainter extends CustomPainter {
  final double scale;
  MapPathPainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 8 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final nodes = LevelMapLayout.nodes;
    if (nodes.isEmpty) return;

    path.moveTo(nodes[0].position.x * scale, nodes[0].position.y * scale);
    for (int i = 1; i < nodes.length; i++) {
      path.lineTo(nodes[i].position.x * scale, nodes[i].position.y * scale);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
