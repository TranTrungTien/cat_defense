import 'dart:math';
import 'package:flutter/material.dart';
import '../cat_defense_game.dart';
import '../components/castle_component.dart';
import '../game_data.dart';

/// ============================================================
/// RESPONSIVE UI:
/// - Game world LUON la 1920x1080 (FixedResolutionViewport) va duoc
///   letterbox GIUA man hinh vat ly.
/// - UI khong duoc tinh theo full man hinh (cu) ma phai nam TRONG
///   khung game: scale = min(w/1920, h/1080), cong them offset
///   letterbox. Nho do tren moi thiet bi (mobile 19.5:9, laptop
///   16:10, tablet...) UI luon trung khop voi the gioi game.
/// ============================================================
class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scale = min(
          constraints.maxWidth / CatDefenseGame.logicalSize.x,
          constraints.maxHeight / CatDefenseGame.logicalSize.y,
        );
        final double gameW = CatDefenseGame.logicalSize.x * scale;
        final double gameH = CatDefenseGame.logicalSize.y * scale;
        final double offX = (constraints.maxWidth - gameW) / 2;
        final double offY = (constraints.maxHeight - gameH) / 2;

        return Stack(
          children: [
            Positioned(
              left: offX,
              top: offY,
              width: gameW,
              height: gameH,
              child: _buildHud(scale),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHud(double scale) {
    return Stack(
      children: [
        // Dai HUD duoi cung
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 185 * scale,
            color: Colors.black.withAlpha(150),
          ),
        ),

        // Top-left: coins + castle HP
        Positioned(top: 24 * scale, left: 24 * scale, child: _coinBar(scale)),
        Positioned(
          top: 104 * scale,
          left: 24 * scale,
          child: _castleHpBar(scale),
        ),

        // Top-right: wave + settings
        Positioned(
          top: 24 * scale,
          right: 24 * scale,
          child: Row(
            children: [
              _waveBar(scale),
              SizedBox(width: 14 * scale),
              _iconButton(
                scale,
                icon: Icons.settings,
                onTap: () {
                  game.pauseEngine();
                  game.overlays.add('Pause');
                },
              ),
            ],
          ),
        ),

        // Bottom: shop meo
        Positioned(
          bottom: 18 * scale,
          left: 20 * scale,
          right: 520 * scale,
          child: _shopBar(scale),
        ),

        // Bottom-right: skills + repair
        Positioned(
          bottom: 24 * scale,
          right: 24 * scale,
          child: Row(
            children: [
              _skillButton(
                scale,
                skillKey: 'spikes',
                iconPath: 'assets/Png/Ui/AddonIcon1.png',
                cost: CatDefenseGame.skillCosts['spikes']!,
              ),
              SizedBox(width: 14 * scale),
              _skillButton(
                scale,
                skillKey: 'tnt',
                iconPath: 'assets/Png/Ui/AddonIcon2.png',
                cost: CatDefenseGame.skillCosts['tnt']!,
              ),
              SizedBox(width: 14 * scale),
              _repairButton(scale),
            ],
          ),
        ),

        _cancelSelection(scale),
        _toast(scale),
      ],
    );
  }

  // ---------- COINS ----------
  Widget _coinBar(double scale) {
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
          Image.asset('assets/Png/Ui/CoinIcon.png', width: 50 * scale),
          SizedBox(width: 15 * scale),
          ValueListenableBuilder<int>(
            valueListenable: game.coins,
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

  // ---------- CASTLE HP ----------
  Widget _castleHpBar(double scale) {
    return ValueListenableBuilder<double>(
      valueListenable: game.castleHp,
      builder: (context, hp, _) => Container(
        width: 260 * scale,
        height: 26 * scale,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(170),
          borderRadius: BorderRadius.circular(13 * scale),
          border: Border.all(
            color: Colors.white.withAlpha(120),
            width: 2 * scale,
          ),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: hp.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: hp > 0.3 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(11 * scale),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- WAVE ----------
  Widget _waveBar(double scale) {
    return Container(
      width: 260 * scale,
      height: 70 * scale,
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
            Image.asset('assets/Png/Ui/DaillyIcon.png', width: 42 * scale),
            SizedBox(width: 10 * scale),
            ValueListenableBuilder<int>(
              valueListenable: game.currentWave,
              builder: (context, wave, _) => Text(
                'Wave ${min(wave, CatDefenseGame.totalWaves)} / ${CatDefenseGame.totalWaves}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * scale,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(blurRadius: 2, offset: Offset(2, 2))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(
    double scale, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70 * scale,
        height: 70 * scale,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(230),
          borderRadius: BorderRadius.circular(14 * scale),
          border: Border.all(color: Colors.black26, width: 2),
        ),
        child: Icon(icon, size: 38 * scale, color: Colors.black87),
      ),
    );
  }

  // ---------- SHOP MEO ----------
  Widget _shopBar(double scale) {
    final cats = catLevels.take(6).toList();
    return SizedBox(
      height: 150 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (context, index) => SizedBox(width: 12 * scale),
        itemBuilder: (context, i) => _catCard(scale, cats[i]),
      ),
    );
  }

  Widget _catCard(double scale, CatLevelData data) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (context, selected, _) {
        final isSelected = selected?.level == data.level;
        return ValueListenableBuilder<int>(
          valueListenable: game.coins,
          builder: (context, coins, _) {
            final afford = coins >= data.cost;
            return GestureDetector(
              onTap: () {
                if (!afford && !isSelected) {
                  game.showToast('Not enough coins!');
                  return;
                }
                game.selectedCatData.value = isSelected ? null : data;
                game.selectedSkill.value = null;
              },
              child: Container(
                width: 118 * scale,
                height: 150 * scale,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange.shade400
                      : Colors.white.withAlpha(235),
                  borderRadius: BorderRadius.circular(16 * scale),
                  border: Border.all(
                    color: isSelected ? Colors.yellow : Colors.white,
                    width: 4 * scale,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pets,
                      size: 44 * scale,
                      color: isSelected ? Colors.white : Colors.orange.shade700,
                    ),
                    Text(
                      'Lv ${data.level}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20 * scale,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Png/Ui/CoinIcon.png',
                          width: 20 * scale,
                        ),
                        SizedBox(width: 4 * scale),
                        Text(
                          '${data.cost}',
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w700,
                            color: !afford
                                ? Colors.red
                                : (isSelected ? Colors.white : Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------- SKILL ----------
  Widget _skillButton(
    double scale, {
    required String skillKey,
    required String iconPath,
    required int cost,
  }) {
    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: game.skillCounts,
      builder: (context, counts, _) {
        final left = counts[skillKey] ?? 0;
        return ValueListenableBuilder<String?>(
          valueListenable: game.selectedSkill,
          builder: (context, sel, _) {
            final isSel = sel == skillKey;
            return ValueListenableBuilder<int>(
              valueListenable: game.coins,
              builder: (context, coins, _) {
                final usable = left > 0 && coins >= cost;
                return GestureDetector(
                  onTap: () {
                    if (left <= 0) {
                      game.showToast('Out of uses!');
                      return;
                    }
                    if (coins < cost) {
                      game.showToast('Not enough coins!');
                      return;
                    }
                    game.selectedSkill.value = isSel ? null : skillKey;
                    game.selectedCatData.value = null;
                  },
                  child: Opacity(
                    opacity: usable ? 1 : 0.45,
                    child: Container(
                      width: 124 * scale,
                      height: 150 * scale,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/Png/Ui/YellowBox.png'),
                          fit: BoxFit.fill,
                        ),
                        border: isSel
                            ? Border.all(color: Colors.red, width: 5 * scale)
                            : null,
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(iconPath, width: 78 * scale),
                          ),
                          Positioned(
                            right: 8 * scale,
                            bottom: 6 * scale,
                            child: Text(
                              '$left',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22 * scale,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8 * scale,
                            bottom: 6 * scale,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/Png/Ui/CoinIcon.png',
                                  width: 18 * scale,
                                ),
                                Text(
                                  '$cost',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16 * scale,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------- REPAIR ----------
  Widget _repairButton(double scale) {
    return ValueListenableBuilder<double>(
      valueListenable: game.castleHp,
      builder: (context, hp, _) {
        return ValueListenableBuilder<int>(
          valueListenable: game.coins,
          builder: (context, coins, _) {
            final cost = CastleComponent.repairCost;
            final usable = hp < 1.0 && coins >= cost;
            return GestureDetector(
              onTap: () {
                if (hp >= 1.0) {
                  game.showToast('Wall is already full HP!');
                  return;
                }
                game.castle.repair();
              },
              child: Opacity(
                opacity: usable ? 1 : 0.5,
                child: Container(
                  width: 130 * scale,
                  height: 150 * scale,
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(240),
                    borderRadius: BorderRadius.circular(16 * scale),
                    border: Border.all(color: Colors.white, width: 4 * scale),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Png/Ui/WallIcon.png',
                        width: 58 * scale,
                      ),
                      Text(
                        'Repair',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18 * scale,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Png/Ui/CoinIcon.png',
                            width: 18 * scale,
                          ),
                          Text(
                            '${cost.toInt()}',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.w800,
                              fontSize: 16 * scale,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------- CANCEL SELECTION ----------
  Widget _cancelSelection(double scale) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (context, cat, _) => ValueListenableBuilder<String?>(
        valueListenable: game.selectedSkill,
        builder: (context, skill, _) {
          final visible = cat != null || skill != null;
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: visible ? 110 * scale : -80 * scale,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  game.selectedCatData.value = null;
                  game.selectedSkill.value = null;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24 * scale,
                    vertical: 10 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(30 * scale),
                    border: Border.all(color: Colors.white, width: 3 * scale),
                  ),
                  child: Text(
                    'Cancel selection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20 * scale,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- TOAST ----------
  Widget _toast(double scale) {
    return ValueListenableBuilder<String?>(
      valueListenable: game.toast,
      builder: (context, msg, _) => AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: msg == null ? 0 : 1,
        child: IgnorePointer(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 120 * scale),
              padding: EdgeInsets.symmetric(
                horizontal: 28 * scale,
                vertical: 14 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(210),
                borderRadius: BorderRadius.circular(16 * scale),
              ),
              child: Text(
                msg ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
