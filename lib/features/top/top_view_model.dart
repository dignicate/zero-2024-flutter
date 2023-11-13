import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/domain/dummy/dummy_use_case.dart';
import 'package:zero_2024_flutter/domain/dummy/todo_domain_object.dart';

part 'top_view_model.freezed.dart';

class TopNotifier extends StateNotifier<TodoUiState> {
  final DummyUseCase _useCase;

  StreamSubscription? _subscription;

  TopNotifier({required DummyUseCase useCase})
      : _useCase = useCase,
        super(const TodoUiState()) {
    _initialize();
  }

  void _initialize() {}
}

@freezed
class TodoUiState with _$TodoUiState {
  const factory TodoUiState({
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(null) TodoViewData? viewData,
  }) = _TodoUistate;
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
