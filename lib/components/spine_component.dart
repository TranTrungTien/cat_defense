import 'package:spine_flutter/spine_flutter.dart';
import 'package:flame/components.dart';
import 'dart:ui';

/// FIX ALIGNMENT: render skeleton TON TRONG anchor cua component.
///
/// - anchor = center (mèo, quái): position = TÂM visual.
///   Đặt component tại slot.size / 2 -> mèo thật sự nằm giữa slot,
///   absolutePosition = tâm mèo -> đạn spawn đúng chỗ.
/// - anchor = topLeft: giữ nguyên hành vi cũ (skeleton căn giữa origin).
class SpineComponent extends PositionComponent {
  final BoundsProvider _boundsProvider;
  late final SkeletonDrawableFlutter _drawable;
  late final Bounds _bounds;
  bool _isInitialized = false;

  SpineComponent({
    BoundsProvider boundsProvider = const SetupPoseBounds(),
    super.position,
    super.scale,
    double super.angle = 0.0,
    Anchor super.anchor = Anchor.topLeft,
    super.children,
    super.priority,
  }) : _boundsProvider = boundsProvider;

  void initSpine(SkeletonDrawableFlutter drawable) {
    _drawable = drawable;
    _drawable.update(0);
    _bounds = _boundsProvider.computeBounds(_drawable);
    size = Vector2(_bounds.width, _bounds.height);
    _isInitialized = true;
  }

  @override
  void update(double dt) {
    if (_isInitialized) {
      _drawable.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    if (_isInitialized) {
      canvas.save();
      // Điểm đặt tâm skeleton trong local box = anchor * size
      final center = anchor.toVector2()..multiply(size);
      canvas.translate(
        center.x - _bounds.x - _bounds.width / 2,
        center.y - _bounds.y - _bounds.height / 2,
      );
      _drawable.renderToCanvas(canvas);
      canvas.restore();
    }
  }

  AnimationState get animationState => _drawable.animationState;
  AnimationStateData get animationStateData => _drawable.animationStateData;
  Skeleton get skeleton => _drawable.skeleton;

  void setFirstAvailableAnimation(List<String> names, {bool loop = true}) {
    for (final name in names) {
      final animation = skeleton.data.findAnimation(name);
      if (animation != null) {
        animationState.setAnimation(0, name, loop);
        return;
      }
    }
  }

  void disposeSpine() {
    _drawable.dispose();
  }
}
