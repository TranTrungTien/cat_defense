import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/ui/game_ui.dart';
import 'package:cat_defense/ui/pause_dialog.dart';
import 'package:cat_defense/ui/win_dialog.dart';
import 'package:cat_defense/ui/lose_dialog.dart';
import 'package:cat_defense/ui/evolution_overlay.dart';
import 'package:cat_defense/ui/perk_selector.dart';

class GameScreen extends StatefulWidget {
  final int level;
  const GameScreen({super.key, this.level = 1});

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
      body: GameWidget<CatDefenseGame>(
        game: _game,
        overlayBuilderMap: {
          'GameUI': (context, game) => GameUI(game: game),
          'Pause': (context, game) => PauseDialog(
            onResume: () {
              game.overlays.remove('Pause');
              game.resumeEngine();
            },
            onRestart: () {
              game.reset();
            },
            onQuit: () => Navigator.pop(context),
          ),
          'WinScreen': (context, game) => WinDialog(
            level: widget.level,
            coinsEarned: widget.level * 200,
            onNextLevel: () => Navigator.pop(context),
            onRestart: () => game.reset(),
            onQuit: () => Navigator.pop(context),
          ),
          'GameOver': (context, game) => LoseDialog(
            onRestart: () => game.reset(),
            onQuit: () => Navigator.pop(context),
          ),
          'Evolution': (context, game) => EvolutionOverlay(game: game),
          'PerkSelector': (context, game) => PerkSelector(game: game),
        },
        initialActiveOverlays: const ['GameUI'],
      ),
    );
  }
}
