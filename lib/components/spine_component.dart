import 'package:spine_flutter/spine_flutter.dart';
import 'package:flame/components.dart';
import 'dart:ui';

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
      // Translate to center the skeleton bounds relative to the component's center
      canvas.translate(-_bounds.x - _bounds.width / 2, -_bounds.y - _bounds.height / 2);
      _drawable.renderToCanvas(canvas);
      canvas.restore();
    }
  }

  AnimationState get animationState => _drawable.animationState;
  AnimationStateData get animationStateData => _drawable.animationStateData;
  Skeleton get skeleton => _drawable.skeleton;

  /// Thử phát một danh sách các tên animation, cái nào tồn tại đầu tiên sẽ được dùng.
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
