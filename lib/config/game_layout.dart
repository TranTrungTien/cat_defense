import 'dart:convert';
import 'package:flame/components.dart';

class SlotDef {
  final String id;
  Vector2 center;
  Vector2 size;
  final bool isWallSlot;
  final bool isDeleteSlot;

  SlotDef(
    this.id,
    this.center,
    this.size, {
    this.isWallSlot = false,
    this.isDeleteSlot = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cx': center.x.round(),
    'cy': center.y.round(),
    'w': size.x.round(),
    'h': size.y.round(),
    if (isWallSlot) 'wall': true,
    if (isDeleteSlot) 'delete': true,
  };

  factory SlotDef.fromJson(Map<String, dynamic> j) => SlotDef(
    j['id'] as String,
    Vector2((j['cx'] as num).toDouble(), (j['cy'] as num).toDouble()),
    Vector2((j['w'] as num).toDouble(), (j['h'] as num).toDouble()),
    isWallSlot: j['wall'] == true,
    isDeleteSlot: j['delete'] == true,
  );
}

class GameLayout {
  static const double worldW = 1920;
  static const double worldH = 1080;

  static Vector2 castlePosition = Vector2(565, 0);

  static double enemySpawnMinY = 240;
  static double enemySpawnMaxY = 660;

  static double gridFootPadding = 10;
  static double wallFootPadding = 6;

  static List<SlotDef> buildDefaults() {
    final slots = <SlotDef>[];

    const cols = [269.0, 389.0];
    const rows = [312.0, 434.0, 554.0, 664.0];
    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < cols.length; c++) {
        slots.add(
          SlotDef('g_${r}_$c', Vector2(cols[c], rows[r]), Vector2(100, 90)),
        );
      }
    }

    const wallYs = [274.0, 394.0, 514.0, 634.0, 744.0];
    for (var i = 0; i < wallYs.length; i++) {
      slots.add(
        SlotDef(
          'w_$i',
          Vector2(544, wallYs[i]),
          Vector2(105, 95),
          isWallSlot: true,
        ),
      );
    }

    slots.add(
      SlotDef(
        'delete',
        Vector2(389, 764),
        Vector2(100, 90),
        isDeleteSlot: true,
      ),
    );

    return slots;
  }

  static List<SlotDef> slots = buildDefaults();

  static SlotDef? find(String id) {
    for (final s in slots) {
      if (s.id == id) return s;
    }
    return null;
  }

  static void updateSlotCenter(String id, Vector2 center) {
    final def = find(id);
    if (def != null) def.center = center;
  }

  static void loadFromJsonString(String src) {
    final list = (jsonDecode(src) as List).cast<Map<String, dynamic>>();
    slots = list.map(SlotDef.fromJson).toList();
  }

  static String exportJson() => const JsonEncoder.withIndent(
    '  ',
  ).convert(slots.map((s) => s.toJson()).toList());
}
