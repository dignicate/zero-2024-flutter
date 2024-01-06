import 'package:flutter/material.dart';
import 'subscription_screen.dart';

class SubscriptionScreenNavigator extends StatelessWidget {
  const SubscriptionScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'subscription/list',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'subscription/list':
            return _buildCustomPageRoute(
              builder: (context) => const SubscriptionListScreen(),
              settings: settings,
            );
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
      },
    );
  }

  PageRoute _buildCustomPageRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 50),
      reverseTransitionDuration: const Duration(milliseconds: 50),
    );
  }
}
