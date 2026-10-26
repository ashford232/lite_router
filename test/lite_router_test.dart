
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lite_router/lite_router.dart';

void main() {
  group('LiteRouter', () {
    testWidgets('push opens a new page', (tester) async {
      final router = LiteRouter();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: router.navigatorKey,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  router.push(
                    const Scaffold(body: Text('Details Page')),
                  );
                },
                child: const Text('Open details'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();

      expect(find.text('Details Page'), findsOneWidget);
    });

    testWidgets('back returns to the previous page', (tester) async {
      final router = LiteRouter();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: router.navigatorKey,
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                router.push(
                  const Scaffold(body: Text('Details Page')),
                );
              },
              child: const Text('Open details'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();

      expect(find.text('Details Page'), findsOneWidget);
      expect(router.canPop(), isTrue);

      router.back();
      await tester.pumpAndSettle();

      expect(find.text('Open details'), findsOneWidget);
      expect(find.text('Details Page'), findsNothing);
      expect(router.canPop(), isFalse);
    });

    testWidgets('canPop is false on the initial page', (tester) async {
      final router = LiteRouter();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: router.navigatorKey,
          home: const Scaffold(body: Text('Home Page')),
        ),
      );

      expect(router.canPop(), isFalse);
    });

    testWidgets('uses the global custom transition', (tester) async {
      var transitionBuilderCalled = false;

      final router = LiteRouter(
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          transitionBuilderCalled = true;

          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: router.navigatorKey,
          home: const Scaffold(body: Text('Home Page')),
        ),
      );

      router.push(
        const Scaffold(body: Text('Details Page')),
      );

      await tester.pump();

      expect(transitionBuilderCalled, isTrue);

      await tester.pumpAndSettle();

      expect(find.text('Details Page'), findsOneWidget);
    });

    testWidgets(
      'per-navigation custom transition overrides global builder',
      (tester) async {
        var globalBuilderCalled = false;
        var overrideBuilderCalled = false;

        final router = LiteRouter(
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            globalBuilderCalled = true;

            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: router.navigatorKey,
            home: const Scaffold(body: Text('Home Page')),
          ),
        );

        router.push(
          const Scaffold(body: Text('Details Page')),
          transitionBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            overrideBuilderCalled = true;

            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );

        await tester.pump();

        expect(overrideBuilderCalled, isTrue);
        expect(globalBuilderCalled, isFalse);

        await tester.pumpAndSettle();

        expect(find.text('Details Page'), findsOneWidget);
      },
    );
  });

  group('LiteRouterContext', () {
    testWidgets('context.push opens a page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  context.push(
                    const Scaffold(body: Text('Context Details')),
                    transition: LiteTransition.fade,
                  );
                },
                child: const Text('Open with context'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open with context'));
      await tester.pumpAndSettle();

      expect(find.text('Context Details'), findsOneWidget);
    });

    testWidgets('context.back returns to the previous page', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  context.push(
                    Scaffold(
                      body: Builder(
                        builder: (detailsContext) => Center(
                          child: ElevatedButton(
                            onPressed: () => detailsContext.back(),
                            child: const Text('Go back'),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Open with context'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open with context'));
      await tester.pumpAndSettle();

      expect(find.text('Go back'), findsOneWidget);

      await tester.tap(find.text('Go back'));
      await tester.pumpAndSettle();

      expect(find.text('Open with context'), findsOneWidget);
      expect(find.text('Go back'), findsNothing);
    });

    testWidgets('context.canPop is false on the initial page', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Text('Can pop: ${context.canPop()}'),
            ),
          ),
        ),
      );

      expect(find.text('Can pop: false'), findsOneWidget);
    });

    testWidgets('context.push supports a custom transition', (
      tester,
    ) async {
      var transitionBuilderCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  context.push(
                    const Scaffold(body: Text('Custom Details')),
                    transitionBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      transitionBuilderCalled = true;

                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                  );
                },
                child: const Text('Open custom'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open custom'));
      await tester.pump();

      expect(transitionBuilderCalled, isTrue);

      await tester.pumpAndSettle();

      expect(find.text('Custom Details'), findsOneWidget);
    });
  });
}
