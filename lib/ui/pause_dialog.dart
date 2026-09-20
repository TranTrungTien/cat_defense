import 'package:flutter/material.dart';

class PauseDialog extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const PauseDialog({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  State<PauseDialog> createState() => _PauseDialogState();
}

class _PauseDialogState extends State<PauseDialog> {
  bool music = true, sound = true, vibra = true, light = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PAUSED GAME',
              style: TextStyle(
                fontFamily: 'PassionOne',
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                shadows: [Shadow(blurRadius: 6, color: Colors.black)],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xCCB07050),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _tog(
                    music,
                    'assets/Png/Ui/BtnMusic.png',
                    'assets/Png/Ui/BtnMusicOff.png',
                    () => setState(() => music = !music),
                  ),
                  _tog(
                    sound,
                    'assets/Png/Ui/BtnSound.png',
                    'assets/Png/Ui/BtnSound_Off.png',
                    () => setState(() => sound = !sound),
                  ),
                  _tog(
                    vibra,
                    'assets/Png/Ui/BtnVibra.png',
                    'assets/Png/Ui/BtnVibra_Off.png',
                    () => setState(() => vibra = !vibra),
                  ),
                  _tog(
                    light,
                    'assets/Png/Ui/BtnHelp.png',
                    'assets/Png/Ui/BtnHelpOff.png',
                    () => setState(() => light = !light),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _imgBtn(
                  'assets/Png/Ui/BtnOrange.png',
                  'Restart',
                  widget.onRestart,
                ),
                const SizedBox(width: 16),
                _imgBtn(
                  'assets/Png/Ui/BtnGreen.png',
                  'Resume',
                  widget.onResume,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tog(bool on, String a, String b, VoidCallback tap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: tap,
        child: Image.asset(on ? a : b, width: 56, height: 56),
      ),
    );
  }

  Widget _imgBtn(String bg, String label, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: SizedBox(
        width: 160,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: Image.asset(bg, fit: BoxFit.fill)),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'PassionOne',
                color: Colors.white,
                fontSize: 18,
                shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
