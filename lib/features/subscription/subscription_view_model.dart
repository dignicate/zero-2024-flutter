import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_domain_object.dart';
import 'package:zero_2024_flutter/domain/subscription/subscription_use_case.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';

part 'subscription_view_model.freezed.dart';

class SubscriptionNotifier extends StateNotifier<SubscriptionUiState> {
  final SubscriptionUseCase _useCase;

  StreamSubscription? _subscription;

  SubscriptionNotifier({required SubscriptionUseCase useCase})
      : _useCase = useCase,
        super(const SubscriptionUiState()) {
    _initialize();
  }

  void _initialize() {
    _subscription = _useCase.resource.listen((data) {
      sharedLogger.d("data: $data");
      data.when(
        data: (data) => {
          state = state.success(data.toViewData())
        },
        loading: () => {
          state = state.loading()
        },
        error: (message) => {
          state = state.error(message)
        },
      );
    });
  }

  void fetch() {
    sharedLogger.d("fetch()");
    _useCase.fetch();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

@freezed
class SubscriptionUiState with _$SubscriptionUiState {
  const factory SubscriptionUiState({
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(null) SubscriptionViewData? viewData,
  }) = _SubscriptionUiState;
}

extension _SubscriptionUiStateExtension on SubscriptionUiState {
  SubscriptionUiState loading() {
    return copyWith(
      isLoading: true,
      errorMessage: null,
    );
  }

  SubscriptionUiState success(SubscriptionViewData viewData) {
    return copyWith(
      isLoading: false,
      errorMessage: null,
      viewData: viewData,
    );
  }

  SubscriptionUiState error(String message) {
    return copyWith(
      isLoading: false,
      errorMessage: message,
    );
  }
}

@freezed
class SubscriptionViewData with _$SubscriptionViewData {
  const factory SubscriptionViewData({
    @Default(null) String? value,
  }) = _SubscriptionViewData;
}

extension _SubscriptionViewDataExtension on SubscriptionDomainObject {
  SubscriptionViewData toViewData({
    String? value,
  }) {
    return SubscriptionViewData(
      value: value ?? this.value,
    );
  }
}
