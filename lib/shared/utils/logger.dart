import 'package:logger/logger.dart';

final sharedLogger = Logger(
  filter: ProductionFilter(),  // 本番時にはデバッグログを非表示にする場合など
  printer: PrettyPrinter(),    // ログのフォーマットを指定
);
