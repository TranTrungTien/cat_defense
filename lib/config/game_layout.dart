import 'dart:convert';
import 'package:flame/components.dart';

/// ============================================================
/// LAYOUT — 1 SLOT = 1 VỊ TRÍ ĐỘC LẬP (không còn dạng lưới hardcode)
///
/// Mỗi slot có: id + TÂM (cx, cy) + kích thước (w, h) tính bằng PIXEL
/// trong world 1920x1080 (world luôn cố định nhờ FixedResolutionViewport,
/// nên tự động đúng trên mọi màn hình vật lý).
///
/// CÓ 2 NGUỒN DỮ LIỆU (theo thứ tự ưu tiên):
///   1. assets/layout.json — nếu có, game load từ file này.
///   2. buildDefaults() — dùng nếu chưa có file json.
///
/// CÁCH CALIBRATE (làm 1 lần, ~3 phút):
///   1. CatDefenseGame.showLayoutDebug = true, chạy game.
///   2. KÉO THẢ từng slot cho trùng art (ô trắng, box cam, thùng rác).
///   3. Mỗi lần thả, toàn bộ layout in ra console dạng JSON.
///   4. Copy JSON đó → lưu thành assets/layout.json
///      (nhớ thêm 'assets/layout.json' vào pubspec).
///   5. Restart → game dùng đúng vị trí đã kéo.
///   6. Đặt showLayoutDebug = false khi release.
/// ============================================================

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

  /// Vị trí castle (thanh cổng) — chỉ là hitbox, không vẽ gì.
  static Vector2 castlePosition = Vector2(565, 0);

  /// Khoảng cách từ CHÂN mèo đến cạnh dưới của slot (pixel, world space).
  /// Chân mèo sẽ nằm CAO HƠN cạnh dưới slot đúng chừng này.
  /// Chỉnh 2 số này nếu muốn mèo đứng sát đáy hơn / cao hơn.
  static double gridFootPadding = 10;
  static double wallFootPadding = 6;

  /// Defaults đã được đo theo dấu 'X' ngưởi dùng đánh dấu trên art:
  ///   - Grid trắng: 2 cột x 4 hàng, tâm các ô bên dưới
  ///   - Wall box cam: 5 ô, cột x = 544
  ///   - Thùng rác: 1 ô
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

  /// Danh sách slot đang hoạt động (có thể đã bị override từ layout.json
  /// hoặc cập nhật khi kéo thả calibrate).
  static List<SlotDef> slots = buildDefaults();

  static SlotDef? find(String id) {
    for (final s in slots) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Gọi khi kéo thả xong 1 slot trong debug mode.
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
