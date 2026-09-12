import 'package:flutter/material.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';

class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = constraints.maxWidth / 1920;
        
        return SafeArea(
          child: Stack(
            children: [
              // Top Left: Coins
              Positioned(
                top: 30 * scale,
                left: 30 * scale,
                child: _buildDesignInfoBar(
                  iconPath: 'assets/Png/Ui/CoinIcon.png',
                  valueNotifier: game.coins,
                  scale: scale,
                ),
              ),

              // Top Right: Wave info
              Positioned(
                top: 30 * scale,
                right: 120 * scale,
                child: Container(
                  width: 280 * scale,
                  height: 75 * scale,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Png/Ui/WaveBar.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/Png/Ui/DaillyIcon.png', width: 45 * scale), 
                        SizedBox(width: 10 * scale),
                        ValueListenableBuilder<int>(
                          valueListenable: game.currentWave,
                          builder: (context, wave, _) => Text(
                            'Wave $wave / 10',
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 26 * scale, 
                              fontWeight: FontWeight.bold,
                              shadows: const [Shadow(blurRadius: 2, offset: Offset(2, 2))],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Right: Skills (Spikes, TNT, Boxing)
              Positioned(
                bottom: 30 * scale,
                right: 30 * scale,
                child: Row(
                  children: [
                    _buildSkillButton('assets/Png/Ui/AddonIcon1.png', '2/5', scale),
                    SizedBox(width: 20 * scale),
                    _buildSkillButton('assets/Png/Ui/AddonIcon2.png', '3/5', scale),
                    SizedBox(width: 20 * scale),
                    _buildSkillButton('assets/Png/Ui/AddonIcon3.png', '2/5', scale),
                  ],
                ),
              ),

              // Bottom Left: Action Buttons (Cat Level & Repair)
              Positioned(
                bottom: 30 * scale,
                left: 30 * scale,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Cat Level Button (Green)
                    GestureDetector(
                      onTap: () {
                        // Logic chọn mèo level 3
                        game.selectedCatData.value = catLevels[2];
                      },
                      child: _buildMainActionButton(
                        iconPath: 'assets/Png/Ui/Uplogo3.png',
                        title: 'Level 3',
                        price: '56780',
                        color: Colors.green,
                        scale: scale,
                      ),
                    ),
                    SizedBox(width: 20 * scale),
                    // Repair Wall Button (Orange)
                    GestureDetector(
                      onTap: () => game.castle.repair(200),
                      child: _buildMainActionButton(
                        iconPath: 'assets/Png/Ui/WallIcon.png',
                        title: 'Repair Wall',
                        price: '56780',
                        color: Colors.orange,
                        scale: scale,
                      ),
                    ),
                    SizedBox(width: 25 * scale),
                    // Trash Bin
                    Image.asset('assets/Png/Ui/BtnHelpOff.png', width: 90 * scale),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesignInfoBar({
    required String iconPath,
    required ValueNotifier<int> valueNotifier,
    required double scale,
  }) {
    return Container(
      width: 260 * scale,
      height: 70 * scale,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Png/Ui/GemsBarBg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10 * scale),
          Image.asset(iconPath, width: 50 * scale),
          SizedBox(width: 15 * scale),
          ValueListenableBuilder<int>(
            valueListenable: valueNotifier,
            builder: (context, value, _) => Text(
              '$value',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 30 * scale, 
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(blurRadius: 2, offset: Offset(2, 2))],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillButton(String iconPath, String count, double scale) {
    return Container(
      width: 130 * scale,
      height: 130 * scale,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Png/Ui/YellowBox.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Center(child: Image.asset(iconPath, width: 90 * scale)),
          Positioned(
            right: 8 * scale,
            bottom: 8 * scale,
            child: Text(
              count, 
              style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.w900, 
                fontSize: 22 * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionButton({
    required String iconPath,
    required String title,
    required String price,
    required Color color,
    required double scale,
  }) {
    return Container(
      width: 310 * scale,
      height: 115 * scale,
      padding: EdgeInsets.symmetric(horizontal: 15 * scale, vertical: 10 * scale),
      decoration: BoxDecoration(
        color: color.withAlpha(235),
        borderRadius: BorderRadius.circular(25 * scale),
        border: Border.all(color: Colors.white, width: 5 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 4, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 85 * scale),
          SizedBox(width: 15 * scale),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: TextStyle(color: Colors.white, fontSize: 24 * scale, fontWeight: FontWeight.w900),
              ),
              Row(
                children: [
                  Image.asset('assets/Png/Ui/CoinIcon.png', width: 28 * scale),
                  SizedBox(width: 8 * scale),
                  Text(
                    price, 
                    style: TextStyle(color: Colors.yellow, fontSize: 26 * scale, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
