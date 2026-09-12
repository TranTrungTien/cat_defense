import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../cat_defense_game.dart';
import '../ui/game_ui.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late CatDefenseGame _game;

  @override
  void initState() {
    super.initState();
    _game = CatDefenseGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'GameOver': (context, game) => GameOverMenu(game: _game),
              'Pause': (context, game) => PauseMenu(game: _game),
            },
          ),
          GameUI(game: _game),
        ],
      ),
    );
  }
}

/// Scale dung cho overlay: FIT theo ca 2 chieu (giong GameUI),
/// Center tu can giua theo khung game vi game duoc letterbox giua man hinh.
double _fitScale(BoxConstraints c) =>
    min(c.maxWidth / 1920.0, c.maxHeight / 1080.0);

class GameOverMenu extends StatelessWidget {
  final CatDefenseGame game;
  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = _fitScale(constraints);

        return Center(
          child: Container(
            width: 400 * scale,
            height: 300 * scale,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Png/Ui/LosePopUp.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60 * scale),
                ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (context, score, child) {
                    return Text(
                      'Score: $score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24 * scale,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20 * scale),
                GestureDetector(
                  onTap: () => game.reset(),
                  child: Image.asset(
                    'assets/Png/Ui/BtnGreen.png',
                    width: 120 * scale,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PauseMenu extends StatelessWidget {
  final CatDefenseGame game;
  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = _fitScale(constraints);

        return Container(
          color: Colors.black.withAlpha(160),
          child: Center(
            child: Container(
              width: 420 * scale,
              padding: EdgeInsets.all(28 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24 * scale),
                border: Border.all(color: Colors.orange, width: 6 * scale),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PAUSED',
                    style: TextStyle(
                      fontSize: 40 * scale,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  SizedBox(height: 30 * scale),
                  _menuButton(scale, 'RESUME', Colors.green, () {
                    game.overlays.remove('Pause');
                    game.resumeEngine();
                  }),
                  SizedBox(height: 16 * scale),
                  _menuButton(scale, 'RESTART', Colors.orange, () {
                    game.reset();
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _menuButton(
    double scale,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14 * scale),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16 * scale),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26 * scale,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
