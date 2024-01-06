import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'main_view_model.freezed.dart';

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier() : super(const MainState.initialized());

  void onAppStarted() async {
    state = const MainState.moveToTopPage();
  }
}

@freezed
class MainState with _$MainState {
  const factory MainState.initialized() = _Initialized;
  const factory MainState.moveToTopPage() = _MoveToTopPage;
}
