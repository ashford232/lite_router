import 'package:flutter/material.dart';

/// Built-in page transition presets for LiteRouter.
enum LiteTransition {
  /// Uses the platform's default Material page transition.
  material,

  /// Slides the new page in from the right.
  slide,

  /// Fades the new page in.
  fade,

  /// Scales the new page into view.
  scale,

  /// Combines fading and sliding.
  fadeSlide,

  /// Slides the new page up from the bottom.
  slideUp,
}

/// Builds the animation for a [LiteTransition].
RouteTransitionsBuilder liteTransitionBuilder(LiteTransition transition) {
  switch (transition) {
    case LiteTransition.material:
      return (_, __, ___, child) => child;

    case LiteTransition.slide:
      return (_, animation, __, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(position: animation.drive(offset), child: child);
      };

    case LiteTransition.fade:
      return (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      };

    case LiteTransition.scale:
      return (_, animation, __, child) {
        final scale = Tween<double>(
          begin: 0.9,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return ScaleTransition(scale: animation.drive(scale), child: child);
      };

    case LiteTransition.fadeSlide:
      return (_, animation, __, child) {
        final offset = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(offset),
            child: child,
          ),
        );
      };

    case LiteTransition.slideUp:
      return (_, animation, __, child) {
        final offset = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(position: animation.drive(offset), child: child);
      };
  }
}
