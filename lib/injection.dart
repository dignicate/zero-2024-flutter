import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:zero_2024_flutter/api/dummy_api_service.dart';
import 'package:zero_2024_flutter/api/interceptors.dart';
import 'package:zero_2024_flutter/data/dummy/dummy_repository_impl.dart';
import 'package:zero_2024_flutter/domain/dummy/dummy_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  // Dioに追加設定を行う
  dio.interceptors.add(CommonInterceptor());
  // タイムアウト設定などもここで可能
  // dio.options.connectTimeout = 5000; // 5秒
  // dio.options.receiveTimeout = 3000; // 3秒
  return dio;
});

final dummyApiServiceProvider = Provider<DummyApiService>((ref) {
  // DioプロバイダーからDioインスタンスを取得
  final dio = ref.watch(dioProvider);
  // TestApiServiceを作成
  return DummyApiService(dio);
});

final dummyRepositoryProvider = Provider<DummyRepository>((ref) {
  final apiService = ref.watch(dummyApiServiceProvider);
  return DummyRepositoryImpl(apiService);
});
