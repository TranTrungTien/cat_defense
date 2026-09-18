import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/components/castle_component.dart';

class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  // ── Assets (đúng path template) ──────────────────────────────────────────
  static const _coinBar = 'Png/Ui/CoinBar.png';
  static const _coinIcon = 'Png/Ui/CoinIcon.png';
  static const _waveBar = 'Png/Ui/WaveBar.png';
  static const _settingBtn = 'Png/Ui/SettingBtn.png';
  static const _greenLevel = 'Png/Ui/GreenLevel.png';
  static const _orangeLvl = 'Png/Ui/OrangeLvl.png';
  static const _wallIcon = 'Png/Ui/WallIcon.png';
  static const _skillFrame = 'Png/Ui/YellowBorderAddon.png';
  static const _skillCountBg = 'Png/Ui/AddonBoxNumber.png';

  static const _iconSpikes = 'Png/Ui/AddonIcon1.png';
  static const _iconTnt = 'Png/Ui/AddonIcon2.png';
  static const _iconBoxer = 'Png/CatBoxing/Idle/CatBoxing-Idle_00.png';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final base = min(
          constraints.maxWidth / CatDefenseGame.logicalSize.x,
          constraints.maxHeight / CatDefenseGame.logicalSize.y,
        );

        final scale = (base * 1.30).clamp(0.45, 1.40);

        return Stack(
          children: [
            Positioned(top: 12 * scale, left: 16 * scale, child: _coin(scale)),
            Positioned(
              top: 12 * scale,
              right: 16 * scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _wave(scale),
                  SizedBox(width: 10 * scale),
                  _settings(scale),
                ],
              ),
            ),
            Positioned(
              left: 12 * scale,
              bottom: 12 * scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _spawnBtn(scale),
                  SizedBox(width: 10 * scale),
                  _repairBtn(scale),
                ],
              ),
            ),
            Positioned(
              right: 12 * scale,
              bottom: 12 * scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _skill(scale, 'spikes', _iconSpikes),
                  SizedBox(width: 8 * scale),
                  _skill(scale, 'tnt', _iconTnt),
                  SizedBox(width: 8 * scale),
                  _skill(scale, 'boxer', _iconBoxer),
                ],
              ),
            ),
            _toast(scale),
          ],
        );
      },
    );
  }

  // ── Coin bar ─────────────────────────────────────────────────────────────
  Widget _coin(double s) {
    return SizedBox(
      width: 180 * s,
      height: 44 * s,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned.fill(child: Image.asset(_coinBar, fit: BoxFit.fill)),
          Padding(
            padding: EdgeInsets.only(left: 10 * s, right: 14 * s),
            child: Row(
              children: [
                Image.asset(_coinIcon, width: 28 * s, height: 28 * s),
                SizedBox(width: 8 * s),
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: game.coins,
                    builder: (_, v, __) => Text(
                      '$v',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PassionOne',
                        color: Colors.white,
                        fontSize: 20 * s,
                        fontWeight: FontWeight.w700,
                        shadows: const [
                          Shadow(blurRadius: 3, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Wave bar ─────────────────────────────────────────────────────────────
  Widget _wave(double s) {
    return SizedBox(
      width: 160 * s,
      height: 40 * s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: Image.asset(_waveBar, fit: BoxFit.fill)),
          ValueListenableBuilder<int>(
            valueListenable: game.currentWave,
            builder: (_, w, __) => Text(
              'Wave ${min(w, CatDefenseGame.totalWaves)} / ${CatDefenseGame.totalWaves}',
              style: TextStyle(
                fontFamily: 'PassionOne',
                color: Colors.white,
                fontSize: 15 * s,
                fontWeight: FontWeight.w700,
                shadows: const [Shadow(blurRadius: 2, color: Colors.black54)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settings(double s) {
    return GestureDetector(
      onTap: () {
        game.pauseEngine();
        game.overlays.add('Pause');
      },
      child: Image.asset(_settingBtn, width: 44 * s, height: 44 * s),
    );
  }

  // ── Spawn Cat button (template: green + cat icon + Level + cost) ─────────
  Widget _spawnBtn(double s) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (_, selected, __) {
        final data = selected ?? getCatDataByLevel(1);
        final lv = data.level;
        final cost = data.cost;
        final selectedOn = selected != null;

        return GestureDetector(
          onTap: () {
            if (selectedOn && selected!.level == lv) {
              game.selectedCatData.value = null;
            } else {
              game.selectedCatData.value = data;
              game.selectedSkill.value = null;
            }
          },
          child: SizedBox(
            width: 220 * s,
            height: 70 * s,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _greenLevel,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6 * s, right: 12 * s),
                  child: Row(
                    children: [
                      Image.asset(
                        'Png/Characters/C$lv/Idle/Character$lv-Idle_00.png',
                        width: 48 * s,
                        height: 48 * s,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.pets,
                          size: 36 * s,
                          color: Colors.orange.shade200,
                        ),
                      ),
                      SizedBox(width: 6 * s),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Level $lv',
                                style: TextStyle(
                                  fontFamily: 'PassionOne',
                                  color: Colors.white,
                                  fontSize: 15 * s,
                                  fontWeight: FontWeight.w700,
                                  height: 1.05,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    _coinIcon,
                                    width: 13 * s,
                                    height: 13 * s,
                                  ),
                                  SizedBox(width: 3 * s),
                                  Text(
                                    '$cost',
                                    style: TextStyle(
                                      fontFamily: 'PassionOne',
                                      color: const Color(0xFFFFE082),
                                      fontSize: 13 * s,
                                      fontWeight: FontWeight.w700,
                                      height: 1.05,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Repair Wall ──────────────────────────────────────────────────────────
  Widget _repairBtn(double s) {
    return ValueListenableBuilder<double>(
      valueListenable: game.castleHp,
      builder: (_, hp, __) {
        return ValueListenableBuilder<int>(
          valueListenable: game.coins,
          builder: (_, coins, __) {
            final cost = CastleComponent.repairCost.toInt();
            final ok = hp < 1.0 && coins >= cost;

            return GestureDetector(
              onTap: ok ? () => game.castle.repair() : null,
              child: Opacity(
                opacity: ok ? 1.0 : 0.45,
                child: SizedBox(
                  width: 190 * s,
                  height: 64 * s,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(_orangeLvl, fit: BoxFit.fill),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10 * s),
                        child: Row(
                          children: [
                            Image.asset(
                              _wallIcon,
                              width: 36 * s,
                              height: 36 * s,
                            ),
                            SizedBox(width: 8 * s),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Repair Wall',
                                  style: TextStyle(
                                    fontFamily: 'PassionOne',
                                    color: Colors.white,
                                    fontSize: 15 * s,
                                    fontWeight: FontWeight.w700,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset(_coinIcon, width: 14 * s),
                                    SizedBox(width: 4 * s),
                                    Text(
                                      '$cost',
                                      style: TextStyle(
                                        fontFamily: 'PassionOne',
                                        color: const Color(0xFFFFE082),
                                        fontSize: 13 * s,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
  }

  // ── Skill buttons ────────────────────────────────────────────────────────
  Widget _skill(double s, String key, String icon) {
    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: game.skillCounts,
      builder: (_, counts, __) {
        final left = counts[key] ?? 0;
        return ValueListenableBuilder<String?>(
          valueListenable: game.selectedSkill,
          builder: (_, sel, __) {
            final on = sel == key;
            return GestureDetector(
              onTap: () {
                if (left <= 0) {
                  game.showToast('Out of uses!');
                  return;
                }
                game.selectedSkill.value = on ? null : key;
                game.selectedCatData.value = null;
              },
              child: Opacity(
                opacity: left > 0 ? 1 : 0.4,
                child: SizedBox(
                  width: 72 * s,
                  height: 72 * s,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Image.asset(_skillFrame, fit: BoxFit.fill),
                      ),
                      if (on)
                        Container(
                          margin: EdgeInsets.all(3 * s),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * s),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.5 * s,
                            ),
                          ),
                        ),
                      Image.asset(
                        icon,
                        width: 42 * s,
                        height: 42 * s,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.help_outline,
                          size: 36 * s,
                          color: Colors.white70,
                        ),
                      ),
                      Positioned(
                        left: 6 * s,
                        right: 6 * s,
                        bottom: 4 * s,
                        child: SizedBox(
                          height: 18 * s,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  _skillCountBg,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                '$left / ${CatDefenseGame.skillMaxCharges}',
                                style: TextStyle(
                                  fontFamily: 'PassionOne',
                                  color: Colors.white,
                                  fontSize: 11 * s,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
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
  }

  // ── Toast ────────────────────────────────────────────────────────────────
  Widget _toast(double s) {
    return ValueListenableBuilder<String?>(
      valueListenable: game.toast,
      builder: (_, msg, __) => AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: msg == null ? 0 : 1,
        child: IgnorePointer(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 80 * s),
              padding: EdgeInsets.symmetric(
                horizontal: 20 * s,
                vertical: 8 * s,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(220),
                borderRadius: BorderRadius.circular(12 * s),
              ),
              child: Text(
                msg ?? '',
                style: TextStyle(
                  fontFamily: 'PassionOne',
                  color: Colors.white,
                  fontSize: 16 * s,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
