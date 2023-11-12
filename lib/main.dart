import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';
import 'injection.dart';

Future<void> main() async {
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  await dotenv.load(fileName: 'config/.env.$env');
  runApp(
    const ProviderScope(
      // ProviderScopeを再度使うようにしてください。
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
      // 初期ルートの場合は`ConpusApp`を返す
      return MaterialPageRoute(builder: (_) => const ZeroApp());
    // case '/login':
    //   // ログインルート
    //   return MaterialPageRoute(builder: (_) => const ZeroApp());
    // case '/home':
    //   // ホーム画面ルート
    //   return MaterialPageRoute(builder: (_) => ZeroApp());
    // 他のルートを追加
    default:
      // 存在しないルートのハンドリング
      return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Not Found'))));
  }
}

class ZeroApp extends HookConsumerWidget {
  const ZeroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO:
    sharedLogger.d('Transition to dummy view.');
    return Text('');
  }
}
