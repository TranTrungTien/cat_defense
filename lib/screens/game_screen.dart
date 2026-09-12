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
            },
          ),
          GameUI(game: _game),
        ],
      ),
    );
  }
}

class GameOverMenu extends StatelessWidget {
  final CatDefenseGame game;
  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = constraints.maxWidth / 1280;
        
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
                SizedBox(height: 60 * scale), // Space for "YOU LOSE" text in image
                ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (context, score, child) {
                    return Text(
                      'Score: $score',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 24 * scale, 
                        fontWeight: FontWeight.bold
                      ),
                    );
                  },
                ),
                SizedBox(height: 20 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        game.overlays.remove('GameOver');
                        game.reset();
                      },
                      child: Image.asset('assets/Png/Ui/BtnGreen.png', width: 120 * scale),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
