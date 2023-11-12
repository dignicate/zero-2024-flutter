import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:zero_2024_flutter/api/test_api_service.dart';
import 'package:zero_2024_flutter/api/interceptors.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  // Dioに追加設定を行う
  dio.interceptors.add(CommonInterceptor());
  // タイムアウト設定などもここで可能
  // dio.options.connectTimeout = 5000; // 5秒
  // dio.options.receiveTimeout = 3000; // 3秒
  return dio;
});

final testApiServiceProvider = Provider<TestApiService>((ref) {
  // DioプロバイダーからDioインスタンスを取得
  final dio = ref.watch(dioProvider);
  // TestApiServiceを作成
  return TestApiService(dio);
});
