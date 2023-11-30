import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/domain/dummy/dummy_use_case.dart';
import 'package:zero_2024_flutter/domain/dummy/todo_domain_object.dart';

part 'top_view_model.freezed.dart';

class TopNotifier extends StateNotifier<TopUiState> {
  final DummyUseCase _useCase;

  StreamSubscription? _subscription;

  TopNotifier({required DummyUseCase useCase})
      : _useCase = useCase,
        super(const TopUiState()) {
    _initialize();
  }

  void _initialize() {
    _subscription = _useCase.resource.listen((data) {
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
    _useCase.fetch();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

@freezed
class TopUiState with _$TopUiState {
  const factory TopUiState({
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(null) TodoViewData? viewData,
  }) = _TopUiState;
}

extension _TopUiStateExtension on TopUiState {
  TopUiState loading() {
    return copyWith(
      isLoading: true,
      errorMessage: null,
    );
  }

  TopUiState error(String errorMessage) {
    return copyWith(
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  TopUiState success(TodoViewData viewData) {
    return copyWith(
      viewData: viewData,
      isLoading: false,
      errorMessage: null,
    );
  }
}

@freezed
class TodoViewData with _$TodoViewData {
  const factory TodoViewData({
    required int userId,
    required int id,
    required String title,
    required bool completed,
  }) = _TodoViewData;
}

extension _TodoDomainObjectExtension on TodoDomainObject {
  TodoViewData toViewData() {
    return TodoViewData(
      userId: userId,
      id: id,
      title: title,
      completed: completed,
    );
  }
}
