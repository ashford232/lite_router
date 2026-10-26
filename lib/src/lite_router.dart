import 'package:flutter/material.dart';

typedef AppPageBuilder = Widget Function(BuildContext context);

/// A lightweight router for navigating between Flutter pages.
class LiteRouter {
  /// Creates a router with an optional custom navigator key.
  LiteRouter({GlobalKey<NavigatorState>? navigatorKey})
    : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  /// The key used to access the app's root navigator.
  final GlobalKey<NavigatorState> navigatorKey;

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

  Route<T> _route<T extends Object?>(Widget page) {
    return MaterialPageRoute<T>(builder: (_) => page);
  }

  /// Push a page onto the navigation stack.
  Future<T?> push<T extends Object?>(Widget page) {
    return _navigator.push<T>(_route<T>(page));
  }

  /// Replace the current page.
  Future<T?> replace<T extends Object?>(Widget page) {
    return _navigator.pushReplacement<T, Object?>(_route<T>(page));
  }

  /// Clear the navigation stack and open a new page.
  Future<T?> to<T extends Object?>(Widget page) {
    return _navigator.pushAndRemoveUntil<T>(_route<T>(page), (_) => false);
  }

  /// Pop the current page and optionally return a result.
  void back<T extends Object?>([T? result]) {
    if (canPop()) {
      _navigator.pop<T>(result);
    }
  }

  /// Pop only when a previous page exists.
  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  /// Attempt to pop the current page.
  Future<bool> maybeBack<T extends Object?>([T? result]) async {
    final state = navigatorKey.currentState;

    if (state == null || !state.canPop()) {
      return false;
    }

    state.pop<T>(result);
    return true;
  }
}
