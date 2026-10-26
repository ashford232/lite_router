import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lite_router/lite_router.dart';

void main() {
  group('LiteRouter', () {
    late LiteRouter router;

    setUp(() {
      router = LiteRouter();
    });

    testWidgets('push opens a new page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: router.navigatorKey,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => router.push(
                  const Scaffold(
                    body: Text('Details Page'),
                  ),
                ),
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
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: router.navigatorKey,
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () => router.push(
                const Scaffold(
                  body: Text('Details Page'),
                ),
              ),
              child: const Text('Open details'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();

      expect(find.text('Details Page'), findsOneWidget);

      router.back();
      await tester.pumpAndSettle();

      expect(find.text('Open details'), findsOneWidget);
      expect(find.text('Details Page'), findsNothing);
    });

    testWidgets('canPop reflects the navigation stack', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: router.navigatorKey,
          home: const Scaffold(
            body: Text('Home Page'),
          ),
        ),
      );

      expect(router.canPop(), isFalse);

      router.push(
        const Scaffold(body: Text('Details Page')),
      );
      await tester.pumpAndSettle();

      expect(router.canPop(), isTrue);
    });
  });
}
