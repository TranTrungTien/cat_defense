import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';
import '../config/game_layout.dart';
import 'cat_component.dart';

class PlacementSlot extends PositionComponent
    with
        HasGameReference<CatDefenseGame>,
        TapCallbacks,
        HoverCallbacks,
        DragCallbacks {
  /// Id trong GameLayout (vd: 'g_0_1', 'w_3', 'delete') — dùng để lưu
  /// lại vị trí khi kéo thả calibrate.
  final String layoutId;
  final bool isWallSlot;
  final bool isDeleteSlot;
  bool isOccupied = false;
  CatComponent? residentCat;
  CatComponent? ghostCat;

  PlacementSlot({
    required this.layoutId,
    required Vector2 position,
    required Vector2 size,
    this.isWallSlot = false,
    this.isDeleteSlot = false,
  }) : super(position: position, size: size);

  bool get _isHovered => game.hoveredSlot == this;

  @override
  void update(double dt) {
    super.update(dt);

    if (isDeleteSlot) return;

    final selectedCat = game.selectedCatData.value;
    final shouldShowGhost = selectedCat != null && !isOccupied && _isHovered;

    if (shouldShowGhost) {
      if (ghostCat == null) {
        final afford = game.coins.value >= selectedCat.cost;
        ghostCat = CatComponent(data: selectedCat, isOnWall: isWallSlot)
          ..position = size / 2
          ..opacity = afford ? 0.6 : 0.25;
        add(ghostCat!);
      } else if (ghostCat!.data.level != selectedCat.level) {
        ghostCat?.removeFromParent();
        ghostCat = null;
      }
    } else if (ghostCat != null) {
      ghostCat?.removeFromParent();
      ghostCat = null;
    }
  }

  @override
  void onHoverEnter() => game.hoveredSlot = this;

  @override
  void onHoverExit() {
    if (game.hoveredSlot == this) game.hoveredSlot = null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.hoveredSlot = this;

    if (isDeleteSlot) {
      game.selectedCatData.value = null;
      game.selectedSkill.value = null;
      return;
    }

    final selectedCat = game.selectedCatData.value;

    if (selectedCat != null && !isOccupied) {
      if (game.coins.value < selectedCat.cost) {
        game.showToast('Not enough coins!');
        return;
      }
      game.coins.value -= selectedCat.cost;
      _placeCat(selectedCat);
      game.selectedCatData.value = null;
    } else if (isOccupied && residentCat != null && selectedCat == null) {
      final refund = (residentCat!.data.cost * 0.5).round();
      game.coins.value += refund;
      game.showToast('Sold! +$refund');
      residentCat?.removeFromParent();
      residentCat = null;
      isOccupied = false;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (game.hoveredSlot == this) game.hoveredSlot = null;
  }

  // ============================================================
  // CHE DO CALIBRATE: khi CatDefenseGame.showLayoutDebug = true,
  // keo tha slot de ghep dung art. Tha tay -> in JSON ra console.
  // Khi debug = false, drag bi bo qua hoan toan (game choi binh thuong).
  // ============================================================
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!CatDefenseGame.showLayoutDebug) return;
    // Bat dau keo — khong can xu ly gi them
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!CatDefenseGame.showLayoutDebug) return;
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!CatDefenseGame.showLayoutDebug) return;
    final center = position + size / 2;
    GameLayout.updateSlotCenter(layoutId, center);
    debugPrint('=== LAYOUT EXPORT — copy vao assets/layout.json ===');
    debugPrint(GameLayout.exportJson());
    game.showToast(
      '$layoutId -> (${center.x.round()}, ${center.y.round()}) — xem console',
    );
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }

  void _placeCat(CatLevelData data) {
    final cat = CatComponent(data: data, isOnWall: isWallSlot)
      ..position = size / 2;
    add(cat);
    residentCat = cat;
    isOccupied = true;

    ghostCat?.removeFromParent();
    ghostCat = null;
  }

  void reset() {
    residentCat?.removeFromParent();
    residentCat = null;
    isOccupied = false;
    ghostCat?.removeFromParent();
    ghostCat = null;
  }
}
