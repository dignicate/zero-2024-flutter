import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/features/common/custom_app_bar.dart';
import 'package:zero_2024_flutter/injection.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';

class SubscriptionListScreen extends HookConsumerWidget {
  const SubscriptionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(subscriptionViewModelProvider.notifier);

    useEffect(() {
      notifier.fetch();
      return null;
    }, const []);

    return const Scaffold(
      appBar: CustomAppBar(
        title: '購読商品リスト',
        showBackButton: true,
      ),
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends HookConsumerWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionViewModelProvider);

    final items = state.viewData?.items;
    sharedLogger.d("items: $items");

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('開発中'),
        ),
        SizedBox(height: 16.0),
        // _ButtonWidget(text: '', onPressed: null),
      ],
    );
  }
}
