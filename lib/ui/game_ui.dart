import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/components/castle_component.dart';
import 'package:cat_defense/components/placement_slot.dart';
import 'package:cat_defense/ui/settings_dialog.dart';

class GameUI extends StatelessWidget {
  final CatDefenseGame game;
  const GameUI({super.key, required this.game});

  // ── Assets (đúng path template) ──────────────────────────────────────────
  static const _coinBar = 'Png/Ui/CoinBar.png';
  static const _coinIcon = 'Png/Ui/CoinIcon.png';
  static const _waveBar = 'Png/Ui/WaveBar.png';
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
            Positioned(top: 12 * scale, left: 16 * scale, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _coin(scale),
                SizedBox(height: 8 * scale),
                _energyBar(scale),
              ],
            )),
            Positioned(
              top: 12 * scale,
              right: 16 * scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ultimateBtn(scale),
                  SizedBox(width: 10 * scale),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _activeSkillBtn(scale),
                  SizedBox(height: 10 * scale),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _skill(scale, 'spikes', _iconSpikes),
                      SizedBox(width: 8 * scale),
                      _skill(scale, 'tnt', _iconTnt),
                      SizedBox(width: 8 * scale),
                      _skill(scale, 'boxer', _iconBoxer),
                    ],
                  ),
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
                    builder: (context, v, _) => Text(
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
            builder: (context, w, _) => Text(
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

  // ── Energy Bar ──────────────────────────────────────────────────────────
  Widget _energyBar(double s) {
    return SizedBox(
      width: 180 * s,
      height: 24 * s,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(12 * s),
              border: Border.all(color: Colors.white24, width: 1.5 * s),
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: game.teamEnergy,
            builder: (context, energy, _) => FractionallySizedBox(
              widthFactor: energy / CatDefenseGame.maxTeamEnergy,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                  ),
                  borderRadius: BorderRadius.circular(12 * s),
                ),
              ),
            ),
          ),
          Center(
            child: ValueListenableBuilder<double>(
              valueListenable: game.teamEnergy,
              builder: (context, energy, _) => Text(
                'Energy: ${energy.toInt()}',
                style: TextStyle(
                  fontFamily: 'PassionOne',
                  color: Colors.white,
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w700,
                  shadows: const [Shadow(blurRadius: 2, color: Colors.black)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Active Skill Button ──────────────────────────────────────────────────
  Widget _activeSkillBtn(double s) {
    return ValueListenableBuilder<PlacementSlot?>(
      valueListenable: game.selectedSlot,
      builder: (context, slot, _) {
        final cat = slot?.residentCat;
        if (cat == null) return const SizedBox.shrink();

        final skill = getHeroSkillById(cat.data.activeSkillId);
        if (skill == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => cat.activateSkill(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skill.name,
                style: TextStyle(
                  fontFamily: 'PassionOne',
                  color: Colors.white,
                  fontSize: 14 * s,
                  shadows: const [Shadow(blurRadius: 2, color: Colors.black)],
                ),
              ),
              SizedBox(height: 4 * s),
              SizedBox(
                width: 64 * s,
                height: 64 * s,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(child: Image.asset(_skillFrame, fit: BoxFit.fill)),
                    Image.asset(
                      skill.iconPath,
                      width: 40 * s,
                      height: 40 * s,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.flash_on, color: Colors.yellow, size: 32 * s),
                    ),
                    // Cooldown overlay
                    ValueListenableBuilder<double>(
                      valueListenable: game.teamEnergy, // Trick to trigger rebuild on energy change, better use a timer or separate notifier
                      builder: (context, energy, _) {
                        final cd = cat.skillCooldownRemaining;
                        if (cd <= 0) return const SizedBox.shrink();
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10 * s),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${cd.toStringAsFixed(1)}s',
                            style: TextStyle(
                              fontFamily: 'PassionOne',
                              color: Colors.white,
                              fontSize: 16 * s,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4 * s),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt, color: Colors.blueAccent, size: 14 * s),
                  Text(
                    '${skill.energyCost}',
                    style: TextStyle(
                      fontFamily: 'PassionOne',
                      color: Colors.blueAccent,
                      fontSize: 14 * s,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Team Ultimate Button ──────────────────────────────────────────────
  Widget _ultimateBtn(double s) {
    return ValueListenableBuilder<double>(
      valueListenable: game.teamUltimate,
      builder: (context, ult, _) {
        final ready = ult >= 100.0;
        return GestureDetector(
          onTap: ready ? () => game.triggerTeamUltimate() : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50 * s,
            height: 50 * s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ready ? Colors.orange : Colors.grey.withAlpha(100),
              boxShadow: ready ? [BoxShadow(color: Colors.orangeAccent, blurRadius: 10 * s, spreadRadius: 2 * s)] : [],
              border: Border.all(color: Colors.white, width: 2 * s),
            ),
            child: Icon(
              Icons.stars,
              color: Colors.white,
              size: 30 * s,
            ),
          ),
        );
      },
    );
  }

  // ── Settings ─────────────────────────────────────────────────────────────
  Widget _settings(double s) {
    return _iconButton(
      s,
      icon: Icons.settings,
      onTap: () => showDialog(
        context: game.buildContext!,
        builder: (_) => const SettingsDialog(),
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

  // ── Spawn Cat button (template: green + cat icon + Level + cost) ─────────
  Widget _spawnBtn(double s) {
    return ValueListenableBuilder<CatLevelData?>(
      valueListenable: game.selectedCatData,
      builder: (context, selected, _) {
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
                        errorBuilder: (context, error, stackTrace) => Icon(
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
      builder: (context, hp, _) {
        return ValueListenableBuilder<int>(
          valueListenable: game.coins,
          builder: (context, coins, _) {
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
      builder: (context, counts, _) {
        final left = counts[key] ?? 0;
        return ValueListenableBuilder<String?>(
          valueListenable: game.selectedSkill,
          builder: (context, sel, _) {
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
                        errorBuilder: (context, error, stackTrace) => Icon(
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
      builder: (context, msg, _) => AnimatedOpacity(
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
