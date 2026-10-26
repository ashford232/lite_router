import 'package:flutter/material.dart';
import 'package:lite_router/lite_router.dart';

void main() {
  runApp(const LiteRouterExample());
}

class LiteRouterExample extends StatelessWidget {
  const LiteRouterExample({super.key});

  static final router = LiteRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiteRouter Example',
      navigatorKey: router.navigatorKey,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LiteRouter')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => LiteRouterExample.router.push(const DetailsPage()),
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => LiteRouterExample.router.back(),
          child: const Text('Go back'),
        ),
      ),
    );
  }
}
