import 'package:dio/dio.dart';

class CommonInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ここに共通のヘッダーやパラメータを追加
    options.headers['Content-Type'] = 'application/json';

    // 共通のクエリパラメータを追加する場合
    // options.queryParameters.addAll({'common_param': 'value'});

    // 次のインターセプターまたはリクエスト送信に進む
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 応答を処理
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // エラーを処理
    handler.next(err);
  }
}
