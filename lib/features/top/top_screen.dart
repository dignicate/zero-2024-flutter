import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/injection.dart';

class TopScreen extends HookConsumerWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(topViewModelProvider);
    final notifier = ref.read(topViewModelProvider.notifier);

    useEffect(() {
      notifier.fetch();
      return null;
    }, const []);

    return Text(state.viewData?.title ?? "No data");
  }
}
