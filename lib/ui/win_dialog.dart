import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';

class WinDialog extends StatefulWidget {
  final int level;
  final int coinsEarned;
  final VoidCallback onNextLevel;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const WinDialog({
    super.key,
    required this.level,
    required this.coinsEarned,
    required this.onNextLevel,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog> {
  @override
  void initState() {
    super.initState();
    _rewardPlayer();
  }

  Future<void> _rewardPlayer() async {
    final manager = PlayerDataManager.instance;
    await manager.completeLevel(widget.level);
    await manager.addCoins(widget.coinsEarned);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "CHIẾN THẮNG!",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Png/Ui/CoinBar.png', width: 28),
                const SizedBox(width: 8),
                Text(
                  "+${widget.coinsEarned}",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.level < 15)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget.onNextLevel,
                child: const Center(
                  child: Text(
                    "MÀN TIẾP THEO",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: widget.onRestart,
              child: const Center(
                child: Text(
                  "CHƠI LẠI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: widget.onQuit,
              child: const Center(child: Text("THOÁT RA MAP")),
            ),
          ],
        ),
      ),
    );
  }
}
