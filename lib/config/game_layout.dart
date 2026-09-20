import 'dart:convert';
import 'package:flame/components.dart';

class SlotDef {
  final String id;
  Vector2 center;
  Vector2 size;
  final bool isWallSlot;
  final bool isDeleteSlot;
  final int laneId;

  SlotDef(
    this.id,
    this.center,
    this.size, {
    this.isWallSlot = false,
    this.isDeleteSlot = false,
    this.laneId = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cx': center.x.round(),
    'cy': center.y.round(),
    'w': size.x.round(),
    'h': size.y.round(),
    if (isWallSlot) 'wall': true,
    if (isDeleteSlot) 'delete': true,
    if (laneId >= 0) 'lane': laneId,
  };

  factory SlotDef.fromJson(Map<String, dynamic> j) => SlotDef(
    j['id'] as String,
    Vector2((j['cx'] as num).toDouble(), (j['cy'] as num).toDouble()),
    Vector2((j['w'] as num).toDouble(), (j['h'] as num).toDouble()),
    isWallSlot: j['wall'] == true,
    isDeleteSlot: j['delete'] == true,
    laneId: (j['lane'] as num?)?.toInt() ?? 0,
  );
}

class GameLayout {
  static const double worldW = 1920;
  static const double worldH = 1080;

  static Vector2 castlePosition = Vector2(565, 0);

  static double enemySpawnMinY = 240;
  static double enemySpawnMaxY = 660;

  static const int laneCount = 5;
  static const List<double> laneYs = [250, 390, 530, 670, 810];
  static double laneY(int lane) => laneYs[lane.clamp(0, laneCount - 1)];

  static double gridFootPadding = 10;
  static double wallFootPadding = 6;

  static List<SlotDef> buildDefaults() {
    final slots = <SlotDef>[];
    const cols = [269.0, 389.0];
    for (var r = 0; r < laneCount; r++) {
      for (var c = 0; c < cols.length; c++) {
        slots.add(
          SlotDef(
            'g_${r}_$c',
            Vector2(cols[c], laneYs[r]),
            Vector2(100, 90),
            laneId: r,
          ),
        );
      }
      slots.add(
        SlotDef(
          'w_$r',
          Vector2(544, laneYs[r] - 20),
          Vector2(105, 95),
          isWallSlot: true,
          laneId: r,
        ),
      );
    }
    slots.add(
      SlotDef(
        'delete',
        Vector2(389, 920),
        Vector2(100, 90),
        isDeleteSlot: true,
        laneId: -1,
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
