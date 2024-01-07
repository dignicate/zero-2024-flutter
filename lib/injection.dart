import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:zero_2024_flutter/api/dummy_api_service.dart';
import 'package:zero_2024_flutter/api/interceptors.dart';
import 'package:zero_2024_flutter/data/dummy/dummy_repository_impl.dart';
import 'package:zero_2024_flutter/data/subscription/subscription_repository_impl.dart';
import 'package:zero_2024_flutter/domain/dummy/dummy_repository.dart';
import 'package:zero_2024_flutter/domain/dummy/dummy_use_case.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_repository.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_use_case.dart';
import 'package:zero_2024_flutter/features/subscription/subscription_view_model.dart';
import 'package:zero_2024_flutter/features/top/top_view_model.dart';

import 'main_view_model.dart';

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

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl();
});

final dummyRepositoryProvider = Provider<DummyRepository>((ref) {
  return DummyRepositoryImpl(
    apiService: ref.watch(dummyApiServiceProvider)
  );
});

final subscriptionUseCaseProvider = Provider<SubscriptionUseCase>((ref) {
  return SubscriptionUseCase(
    subscriptionRepository: ref.watch(subscriptionRepositoryProvider),
    // dummyRepository: ref.watch(dummyRepositoryProvider)
  );
});

final dummyUseCaseProvider = Provider<DummyUseCase>((ref) {
  return DummyUseCase(
    dummyRepository: ref.watch(dummyRepositoryProvider)
  );
});

final subscriptionViewModelProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionUiState>((ref) {
  return SubscriptionNotifier(
    useCase: ref.watch(subscriptionUseCaseProvider),
  );
});

final topViewModelProvider = StateNotifierProvider<TopNotifier, TopUiState>((ref) {
  return TopNotifier(
    useCase: ref.watch(dummyUseCaseProvider),
  );
});

final mainViewModelProvider = StateNotifierProvider<MainNotifier, MainState>((ref) {
  return MainNotifier();
});
