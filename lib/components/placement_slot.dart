import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../cat_defense_game.dart';
import '../game_data.dart';
import 'cat_component.dart';

class PlacementSlot extends PositionComponent with HasGameReference<CatDefenseGame>, TapCallbacks {
  final bool isWallSlot; 
  final bool isDeleteSlot;
  bool isOccupied = false;
  CatComponent? residentCat;
  CatComponent? ghostCat; 

  PlacementSlot({
    required Vector2 position,
    required Vector2 size,
    this.isWallSlot = false,
    this.isDeleteSlot = false,
  }) : super(position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    
    // Không cho phép đặt mèo vào ô Delete
    if (isDeleteSlot) return;

    final selectedCat = game.selectedCatData.value;
    
    if (selectedCat != null && !isOccupied) {
      if (ghostCat == null) {
        ghostCat = CatComponent(data: selectedCat, isOnWall: isWallSlot)
          ..position = size / 2 // Position relative to slot
          ..opacity = 0.5;
        add(ghostCat!); // Add as child of slot for better alignment
      } else if (ghostCat!.data.level != selectedCat.level) {
        ghostCat?.removeFromParent();
        ghostCat = null;
      }
    } else {
      if (ghostCat != null) {
        ghostCat?.removeFromParent();
        ghostCat = null;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isDeleteSlot) {
      // Logic xóa mèo đang chọn hoặc có thể tap vào mèo đã đặt để xóa (cần logic thêm)
      game.selectedCatData.value = null;
      return;
    }

    final selectedCat = game.selectedCatData.value;
    
    if (selectedCat != null && !isOccupied && game.coins.value >= selectedCat.cost) {
      game.coins.value -= selectedCat.cost;
      _placeCat(selectedCat);
      game.selectedCatData.value = null;
    } else if (isOccupied && residentCat != null && game.selectedCatData.value == null) {
      // Nếu tap vào ô đã có mèo mà không chọn mèo nào -> Có thể bán/xóa
      residentCat?.removeFromParent();
      residentCat = null;
      isOccupied = false;
    }
  }

  void _placeCat(CatLevelData data) {
    final cat = CatComponent(data: data, isOnWall: isWallSlot)
      ..position = size / 2;
    add(cat); // Add as child of slot
    residentCat = cat;
    isOccupied = true;
    
    ghostCat?.removeFromParent();
    ghostCat = null;
  }
}
