import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/features/common/custom_app_bar.dart';
import 'package:zero_2024_flutter/injection.dart';
import 'package:zero_2024_flutter/shared/utils/logger.dart';

import 'subscription_view_model.dart';

class SubscriptionListScreen extends HookConsumerWidget {
  const SubscriptionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(subscriptionViewModelProvider.notifier);

    useEffect(() {
      // notifier.fetch();
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // ここで垂直方向の中央揃え
        children:
          items != null ?
            items.map((item) {
              return ProductButton(item: item);
            }).toList()
          : [
            const Text('購読商品がありません'),
          ],
      ),
    );

  }
}

class ProductButton extends StatelessWidget {
  final SubscriptionViewDataItem item;

  const ProductButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {
          // ここに購入処理を追加
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item.name),
              Text(item.price),
            ],
          ),
        ),
      ),
    );
  }
}
