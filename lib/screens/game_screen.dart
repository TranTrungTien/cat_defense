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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'GameOver': (context, game) => GameOverMenu(game: _game),
              'Pause': (context, game) => PauseMenu(game: _game),
              'WinScreen': (context, game) => WinScreen(game: _game),
            },
          ),
          GameUI(game: _game),
        ],
      ),
    );
  }
}

double _fitScale(BoxConstraints c) => c.maxHeight / 1080.0;

// Base Popup Dialog chuẩn UI/UX
class _BaseModal extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Widget content;
  final VoidCallback onAction;
  final String actionText;
  final double scale;

  const _BaseModal({
    required this.title,
    required this.titleColor,
    required this.content,
    required this.onAction,
    required this.actionText,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(160),
      child: Center(
        child: Container(
          width: 480 * scale,
          padding: EdgeInsets.symmetric(
            horizontal: 32 * scale,
            vertical: 24 * scale,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(24 * scale),
            border: Border.all(color: Colors.white24, width: 3 * scale),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 36 * scale,
                  fontWeight: FontWeight.w900,
                  color: titleColor,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20 * scale),
              content,
              SizedBox(height: 24 * scale),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40 * scale,
                    vertical: 14 * scale,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16 * scale),
                  ),
                ),
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 22 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
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
        final scale = _fitScale(constraints);
        return _BaseModal(
          title: 'DEFEAT',
          titleColor: Colors.redAccent,
          scale: scale,
          actionText: 'TRY AGAIN',
          onAction: game.reset,
          content: ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (context, score, _) => Text(
              'Final Score: $score',
              style: TextStyle(color: Colors.white70, fontSize: 20 * scale),
            ),
          ),
        );
      },
    );
  }
}

class WinScreen extends StatelessWidget {
  final CatDefenseGame game;
  const WinScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = _fitScale(constraints);
        return _BaseModal(
          title: 'VICTORY!',
          titleColor: Colors.greenAccent,
          scale: scale,
          actionText: 'PLAY AGAIN',
          onAction: game.reset,
          content: ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (context, score, _) => Text(
              'Final Score: $score',
              style: TextStyle(color: Colors.white70, fontSize: 20 * scale),
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
        final scale = _fitScale(constraints);
        return Container(
          color: Colors.black.withAlpha(160),
          child: Center(
            child: Container(
              width: 420 * scale,
              padding: EdgeInsets.all(28 * scale),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(24 * scale),
                border: Border.all(color: Colors.white24, width: 2 * scale),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PAUSED',
                    style: TextStyle(
                      fontSize: 36 * scale,
                      fontWeight: FontWeight.w900,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 24 * scale),
                  _btn(scale, 'RESUME', Colors.green, () {
                    game.overlays.remove('Pause');
                    game.resumeEngine();
                  }),
                  SizedBox(height: 14 * scale),
                  _btn(scale, 'RESTART', Colors.orange, game.reset),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _btn(double scale, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12 * scale),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14 * scale),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
