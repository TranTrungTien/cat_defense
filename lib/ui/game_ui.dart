import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/components/castle_component.dart';
import 'package:cat_defense/components/placement_slot.dart';
import 'package:cat_defense/game_data.dart';

class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / CatDefenseGame.logicalSize.x;
        final scaleY = constraints.maxHeight / CatDefenseGame.logicalSize.y;
        final double scale = min(scaleX, scaleY);

        return SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 12 * scale,
                left: 16 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _coinBar(scale),
                    SizedBox(height: 8 * scale),
                    _castleHpBar(scale),
                  ],
                ),
              ),

              Positioned(
                top: 12 * scale,
                right: 16 * scale,
                child: Row(
                  children: [
                    _waveBar(scale),
                    SizedBox(width: 10 * scale),
                    _iconButton(
                      scale,
                      icon: Icons.pause_rounded,
                      onTap: () {
                        game.pauseEngine();
                        game.overlays.add('Pause');
                      },
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 12 * scale,
                left: 16 * scale,
                right: 16 * scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _shopBar(scale)),
                    SizedBox(width: 16 * scale),
                    Row(
                      children: [
                        _skillButton(
                          scale,
                          skillKey: 'spikes',
                          iconPath: 'assets/Png/Ui/AddonIcon1.png',
                          cost: CatDefenseGame.skillCosts['spikes']!,
                        ),
                        SizedBox(width: 8 * scale),
                        _skillButton(
                          scale,
                          skillKey: 'tnt',
                          iconPath: 'assets/Png/Ui/AddonIcon2.png',
                          cost: CatDefenseGame.skillCosts['tnt']!,
                        ),
                        SizedBox(width: 8 * scale),
                        _repairButton(scale),
                      ],
                    ),
                  ],
                ),
              ),

              _cancelSelection(scale),
              _catActionMenu(scale),
              _toast(scale),
            ],
          ),
        );
      },
    );
  }

  Widget _coinBar(double scale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 6 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(200),
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(
          color: Colors.amber.withAlpha(180),
          width: 2 * scale,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/Png/Ui/CoinIcon.png', width: 26 * scale),
          SizedBox(width: 8 * scale),
          ValueListenableBuilder<int>(
            valueListenable: game.coins,
            builder: (context, value, _) => Text(
              '$value',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 20 * scale,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _castleHpBar(double scale) {
    return ValueListenableBuilder<double>(
      valueListenable: game.castleHp,
      builder: (context, hp, _) => Container(
        width: 180 * scale,
        height: 16 * scale,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          borderRadius: BorderRadius.circular(10 * scale),
          border: Border.all(color: Colors.white24, width: 1.5 * scale),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: hp.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: hp > 0.3 ? Colors.greenAccent : Colors.redAccent,
              borderRadius: BorderRadius.circular(8 * scale),
            ),
          ),
        ),
      ),
    );
  }

  Widget _waveBar(double scale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 8 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(200),
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(color: Colors.white24, width: 1.5 * scale),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: game.currentWave,
        builder: (context, wave, _) => Text(
          'WAVE ${min(wave, CatDefenseGame.totalWaves)} / ${CatDefenseGame.totalWaves}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16 * scale,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
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
        width: 42 * scale,
        height: 42 * scale,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(color: Colors.white24, width: 1.5 * scale),
        ),
        child: Icon(icon, size: 24 * scale, color: Colors.white),
      ),
    );
  }

  Widget _shopBar(double scale) {
    final cats = catLevels.take(5).toList();
    return SizedBox(
      height: 95 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (context, index) => SizedBox(width: 8 * scale),
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
              child: Opacity(
                opacity: afford ? 1.0 : 0.5,
                child: Container(
                  width: 75 * scale,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.amber.shade700
                        : const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12 * scale),
                    border: Border.all(
                      color: isSelected ? Colors.amberAccent : Colors.white24,
                      width: isSelected ? 2.5 * scale : 1.5 * scale,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 26 * scale,
                        color: isSelected ? Colors.white : Colors.amber,
                      ),
                      SizedBox(height: 2 * scale),
                      Text(
                        'Lv ${data.level}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13 * scale,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${data.cost}',
                        style: TextStyle(
                          fontSize: 12 * scale,
                          fontWeight: FontWeight.w600,
                          color: afford ? Colors.amberAccent : Colors.redAccent,
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
  }

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
                      width: 75 * scale,
                      height: 95 * scale,
                      decoration: BoxDecoration(
                        color: isSel
                            ? Colors.redAccent.shade400
                            : const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12 * scale),
                        border: Border.all(
                          color: isSel ? Colors.white : Colors.white24,
                          width: 2 * scale,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(iconPath, width: 38 * scale),
                          ),
                          Positioned(
                            right: 6 * scale,
                            top: 4 * scale,
                            child: Text(
                              'x$left',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11 * scale,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 4 * scale,
                            child: Text(
                              '$cost',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12 * scale,
                                color: Colors.amber,
                              ),
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
              onTap: usable ? game.castle.repair : null,
              child: Opacity(
                opacity: usable ? 1 : 0.45,
                child: Container(
                  width: 75 * scale,
                  height: 95 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12 * scale),
                    border: Border.all(
                      color: Colors.white24,
                      width: 1.5 * scale,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.build_rounded,
                        size: 26 * scale,
                        color: Colors.greenAccent,
                      ),
                      SizedBox(height: 2 * scale),
                      Text(
                        'Repair',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12 * scale,
                        ),
                      ),
                      Text(
                        '${cost.toInt()}',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 11 * scale,
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
  }

  Widget _cancelSelection(double scale) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (context, cat, _) => ValueListenableBuilder<String?>(
        valueListenable: game.selectedSkill,
        builder: (context, skill, _) {
          final visible = cat != null || skill != null;
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: visible ? 70 * scale : -80 * scale,
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
                    horizontal: 18 * scale,
                    vertical: 6 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16 * scale),
                  ),
                  child: Text(
                    'Cancel Selection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13 * scale,
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

  Widget _catActionMenu(double scale) {
    return ValueListenableBuilder<PlacementSlot?>(
      valueListenable: game.selectedSlot,
      builder: (context, slot, _) {
        final cat = slot?.residentCat;
        if (slot == null || cat == null) return const SizedBox.shrink();
        return Positioned(
          top: 150 * scale,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 6 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(220),
                borderRadius: BorderRadius.circular(14 * scale),
                border: Border.all(color: Colors.white24, width: 1.5 * scale),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionButton(
                    scale,
                    label: 'Upgrade (${cat.data.upgradeCost})',
                    icon: Icons.arrow_upward,
                    color: Colors.greenAccent,
                    onTap: slot.upgradeCat,
                  ),
                  SizedBox(width: 8 * scale),
                  _actionButton(
                    scale,
                    label: 'Sell (${(cat.data.cost * 0.5).round()})',
                    icon: Icons.sell,
                    color: Colors.orangeAccent,
                    onTap: slot.sellCat,
                  ),
                  SizedBox(width: 8 * scale),
                  _actionButton(
                    scale,
                    label: 'Close',
                    icon: Icons.close,
                    color: Colors.white70,
                    onTap: () => game.selectedSlot.value = null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(
    double scale, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10 * scale,
          vertical: 5 * scale,
        ),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8 * scale),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16 * scale),
            SizedBox(width: 4 * scale),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toast(double scale) {
    return ValueListenableBuilder<String?>(
      valueListenable: game.toast,
      builder: (context, msg, _) => AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: msg == null ? 0 : 1,
        child: IgnorePointer(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 80 * scale),
              padding: EdgeInsets.symmetric(
                horizontal: 20 * scale,
                vertical: 8 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(220),
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              child: Text(
                msg ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
