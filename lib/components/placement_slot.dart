import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:cat_defense/cat_defense_game.dart';
import 'package:cat_defense/game_data.dart';
import 'package:cat_defense/config/game_layout.dart';
import 'package:cat_defense/components/cat_component.dart';

class PlacementSlot extends PositionComponent
    with
        HasGameReference<CatDefenseGame>,
        TapCallbacks,
        HoverCallbacks,
        DragCallbacks {
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
        ghostCat =
            CatComponent(data: selectedCat, isOnWall: isWallSlot, isGhost: true)
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
      game.selectedSlot.value = null;
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
      game.selectedSlot.value = null;
    } else if (isOccupied && residentCat != null && selectedCat == null) {
      game.selectedSlot.value = this;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (game.hoveredSlot == this) game.hoveredSlot = null;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (CatDefenseGame.showLayoutDebug) return;

    if (isOccupied && residentCat != null) {
      game.draggingCatSlot = this;
      residentCat!.opacity = 0.5;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (CatDefenseGame.showLayoutDebug) {
      position += event.localDelta;
      return;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (CatDefenseGame.showLayoutDebug) {
      final center = position + size / 2;
      GameLayout.updateSlotCenter(layoutId, center);
      debugPrint('=== LAYOUT EXPORT ===');
      debugPrint(GameLayout.exportJson());
      game.showToast('$layoutId -> (${center.x.round()}, ${center.y.round()})');
      return;
    }

    if (game.draggingCatSlot == this) {
      final target = game.hoveredSlot;
      if (target != null && target != this && !target.isDeleteSlot) {
        _handleDropOn(target);
      } else if (target?.isDeleteSlot == true) {
        sellCat();
      }

      residentCat?.opacity = 1.0;
      game.draggingCatSlot = null;
    }
  }

  void _handleDropOn(PlacementSlot target) {
    final myCat = residentCat;
    if (myCat == null) return;

    if (target.isOccupied && target.residentCat != null) {
      final otherCat = target.residentCat!;

      // MERGE LOGIC
      if (myCat.data.tier == otherCat.data.tier && myCat.data.evolutionIds.isNotEmpty) {
        _triggerMerge(target);
      } else {
        // SWAP LOGIC
        _swapWith(target);
      }
    } else {
      // MOVE LOGIC
      _moveTo(target);
    }
  }

  void _triggerMerge(PlacementSlot target) {
    // Keep reference to both slots involved in merge
    game.draggingCatSlot = this; // Ingredient 1
    game.selectedSlot.value = target; // Ingredient 2 & Result slot
    game.selectedCatData.value = residentCat!.data;

    game.overlays.add('Evolution');
  }

  void _swapWith(PlacementSlot target) {
    final otherCatData = target.residentCat!.data;
    final myCatData = residentCat!.data;

    target.residentCat?.removeFromParent();
    residentCat?.removeFromParent();

    target._placeCat(myCatData);
    _placeCat(otherCatData);
  }

  void _moveTo(PlacementSlot target) {
    final data = residentCat!.data;
    residentCat?.removeFromParent();
    residentCat = null;
    isOccupied = false;

    target._placeCat(data);
  }

  void placeFromHud(CatLevelData data) => _placeCat(data);

  void _placeCat(CatLevelData data) {
    final cat = CatComponent(data: data, isOnWall: isWallSlot)
      ..position = size / 2;
    add(cat);
    residentCat = cat;
    isOccupied = true;

    ghostCat?.removeFromParent();
    ghostCat = null;
  }

  void sellCat() {
    final cat = residentCat;
    if (cat == null) return;
    final refund = (cat.data.cost * 0.5).round();
    game.coins.value += refund;
    game.showToast('Sold! +$refund');
    cat.removeFromParent();
    residentCat = null;
    isOccupied = false;
    game.selectedSlot.value = null;
  }

  void upgradeCat() {
    final cat = residentCat;
    if (cat == null) return;

    if (cat.data.evolutionIds.isEmpty) {
      game.showToast('Max level reached');
      return;
    }

    if (game.coins.value < cat.data.upgradeCost) {
      game.showToast('Not enough coins!');
      return;
    }

    // Mo Evolution UI giong nhu khi merge
    game.selectedSlot.value = this;
    game.selectedCatData.value = cat.data;
    game.overlays.add('Evolution');
  }

  void reset() {
    residentCat?.removeFromParent();
    residentCat = null;
    isOccupied = false;
    game.selectedSlot.value = null;
    ghostCat?.removeFromParent();
    ghostCat = null;
  }
}
