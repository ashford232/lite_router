import 'package:flutter/material.dart';
import 'package:lite_router/lite_router.dart';

void main() {
  runApp(const LiteRouterExample());
}

class LiteRouterExample extends StatelessWidget {
  const LiteRouterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'LiteRouter Example', home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LiteRouter')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose a transition',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      const DetailsPage(),
                      transition: LiteTransition.material,
                    );
                  },
                  child: const Text('Material'),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      const DetailsPage(),
                      transition: LiteTransition.slide,
                    );
                  },
                  child: const Text('Slide'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      const DetailsPage(),
                      transition: LiteTransition.fade,
                    );
                  },
                  child: const Text('Fade'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      const DetailsPage(),
                      transition: LiteTransition.scale,
                    );
                  },
                  child: const Text('Scale'),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      const DetailsPage(),
                      transition: LiteTransition.fadeSlide,
                    );
                  },
                  child: const Text('Fade Slide'),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      const DetailsPage(),
                      transition: LiteTransition.slideUp,
                    );
                  },
                  child: const Text('Slide Up'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      const DetailsPage(),
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return RotationTransition(
                              turns: Tween<double>(
                                begin: 0.05,
                                end: 0,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                    );
                  },
                  child: const Text('Custom (rotate + fade)'),
                ),
              ),
            ],
          ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Transition successful!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
