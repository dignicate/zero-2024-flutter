import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:zero_2024_flutter/features/subscription/subscription_screen.dart';
import 'package:zero_2024_flutter/features/top/top_screen.dart';
import 'injection.dart';

Future<void> main() async {
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  await dotenv.load(fileName: 'config/.env.$env');
  runApp(
    const ProviderScope(
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    ),
  );
}

Route<dynamic> _generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const ZeroApp());
    case '/top':
      return MaterialPageRoute(builder: (_) => const TopScreen());
    case '/subscription':
      return MaterialPageRoute(builder: (_) => const SubscriptionListScreen());
    default:
      return MaterialPageRoute(
        builder: (_) =>
          const Scaffold(body: Center(child: Text('Not Found'))));
  }
}

class ZeroApp extends HookConsumerWidget {
  const ZeroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);


    useEffect(() {
      Future.microtask(() => notifier.onAppStarted());
      return null;
    }, const []);

    return state.when(
      initialized: () {
        return Container(
          color: Colors.white,
          child: const Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      moveToTopPage: () {
        return const TopScreen();
      }
    );
  }


}
