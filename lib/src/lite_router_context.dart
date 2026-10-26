import 'package:flutter/material.dart';

import 'lite_transition.dart';

/// Navigation extensions for BuildContext.
extension LiteRouterContext on BuildContext {
  NavigatorState get _navigator {
    final navigator = Navigator.maybeOf(this);

    if (navigator == null) {
      throw StateError('No Navigator found in this context.');
    }

    return navigator;
  }

  Route<T> _createRoute<T extends Object?>(
    Widget page, {
    LiteTransition transition = LiteTransition.material,
    RouteTransitionsBuilder? transitionBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration? reverseTransitionDuration,
  }) {
    final builder =
        transitionBuilder ??
        (transition == LiteTransition.material
            ? null
            : liteTransitionBuilder(transition));

    if (builder == null) {
      return MaterialPageRoute<T>(builder: (_) => page);
    }

    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: builder,
      transitionDuration: transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? transitionDuration,
    );
  }

  /// Pushes a page using the nearest Navigator.
  Future<T?> push<T extends Object?>(
    Widget page, {
    LiteTransition transition = LiteTransition.material,
    RouteTransitionsBuilder? transitionBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration? reverseTransitionDuration,
  }) {
    return _navigator.push<T>(
      _createRoute<T>(
        page,
        transition: transition,
        transitionBuilder: transitionBuilder,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
      ),
    );
  }

  /// Replaces the current page.
  Future<T?> replace<T extends Object?>(
    Widget page, {
    LiteTransition transition = LiteTransition.material,
    RouteTransitionsBuilder? transitionBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration? reverseTransitionDuration,
  }) {
    return _navigator.pushReplacement<T, Object?>(
      _createRoute<T>(
        page,
        transition: transition,
        transitionBuilder: transitionBuilder,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
      ),
    );
  }

  /// Clears the navigation stack and opens a new page.
  Future<T?> to<T extends Object?>(
    Widget page, {
    LiteTransition transition = LiteTransition.material,
    RouteTransitionsBuilder? transitionBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration? reverseTransitionDuration,
  }) {
    return _navigator.pushAndRemoveUntil<T>(
      _createRoute<T>(
        page,
        transition: transition,
        transitionBuilder: transitionBuilder,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
      ),
      (_) => false,
    );
  }

  /// Pops the current page if possible.
  void back<T extends Object?>([T? result]) {
    if (_navigator.canPop()) {
      _navigator.pop<T>(result);
    }
  }

  /// Returns whether the nearest Navigator can pop.
  bool canPop() => _navigator.canPop();

  /// Attempts to pop the current page.
  Future<bool> maybeBack<T extends Object?>([T? result]) async {
    if (!_navigator.canPop()) {
      return false;
    }

    _navigator.pop<T>(result);
    return true;
  }
}
