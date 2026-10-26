import 'package:flutter/material.dart';

import 'lite_transition.dart';

/// Builds a page widget from a navigation context.
typedef AppPageBuilder = Widget Function(BuildContext context);

/// A lightweight navigation helper with configurable page transitions.
class LiteRouter {
  /// Creates a router with optional global transition defaults.
  ///
  /// Defaults to [LiteTransition.material] to preserve the existing
  /// MaterialPageRoute behavior.
  ///
  /// A per-navigation transition overrides the global transition.
  /// A custom [transitionBuilder] takes precedence over a preset.
  LiteRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    this.transition = LiteTransition.material,
    this.transitionBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    Duration? reverseTransitionDuration,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
       reverseTransitionDuration =
           reverseTransitionDuration ?? transitionDuration;

  /// The navigator key to attach to a [MaterialApp].
  final GlobalKey<NavigatorState> navigatorKey;

  /// The default built-in transition preset.
  final LiteTransition transition;

  /// An optional custom global transition builder.
  ///
  /// When provided, this takes precedence over [transition].
  final RouteTransitionsBuilder? transitionBuilder;

  /// The default duration for transitions.
  final Duration transitionDuration;

  /// The default duration for reverse transitions.
  final Duration reverseTransitionDuration;

  NavigatorState get _navigator {
    final state = navigatorKey.currentState;

    if (state == null) {
      throw StateError(
        'LiteRouter is not attached to a Navigator. '
        'Pass its navigatorKey to MaterialApp.',
      );
    }

    return state;
  }

  Route<T> _route<T extends Object?>(
    Widget page, {
    LiteTransition? transition,
    RouteTransitionsBuilder? transitionBuilder,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    final selectedTransition = transition ?? this.transition;

    final effectiveTransitionBuilder =
        transitionBuilder ??
        this.transitionBuilder ??
        (selectedTransition == LiteTransition.material
            ? null
            : liteTransitionBuilder(selectedTransition));

    // Preserve the original MaterialPageRoute behavior when no custom
    // transition builder or non-material preset has been selected.
    if (effectiveTransitionBuilder == null) {
      return MaterialPageRoute<T>(builder: (_) => page);
    }

    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: effectiveTransitionBuilder,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
    );
  }

  /// Pushes a page onto the navigation stack.
  ///
  /// The optional [transition] overrides the global preset.
  /// The optional [transitionBuilder] overrides both presets and the
  /// global custom builder.
  Future<T?> push<T extends Object?>(
    Widget page, {
    LiteTransition? transition,
    RouteTransitionsBuilder? transitionBuilder,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return _navigator.push<T>(
      _route<T>(
        page,
        transition: transition,
        transitionBuilder: transitionBuilder,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
      ),
    );
  }

  /// Replaces the current page.
  ///
  /// Supports the same transition overrides as [push].
  Future<T?> replace<T extends Object?>(
    Widget page, {
    LiteTransition? transition,
    RouteTransitionsBuilder? transitionBuilder,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return _navigator.pushReplacement<T, Object?>(
      _route<T>(
        page,
        transition: transition,
        transitionBuilder: transitionBuilder,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
      ),
    );
  }

  /// Clears the navigation stack and opens a new page.
  ///
  /// Supports the same transition overrides as [push].
  Future<T?> to<T extends Object?>(
    Widget page, {
    LiteTransition? transition,
    RouteTransitionsBuilder? transitionBuilder,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return _navigator.pushAndRemoveUntil<T>(
      _route<T>(
        page,
        transition: transition,
        transitionBuilder: transitionBuilder,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
      ),
      (_) => false,
    );
  }

  /// Pops the current page and optionally returns a result.
  void back<T extends Object?>([T? result]) {
    if (canPop()) {
      _navigator.pop<T>(result);
    }
  }

  /// Returns whether the navigator can pop a page.
  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  /// Attempts to pop the current page.
  Future<bool> maybeBack<T extends Object?>([T? result]) async {
    final state = navigatorKey.currentState;

    if (state == null || !state.canPop()) {
      return false;
    }

    state.pop<T>(result);
    return true;
  }
}
