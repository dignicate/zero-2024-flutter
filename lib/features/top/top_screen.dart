import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/features/common/custom_app_bar.dart';
import 'package:zero_2024_flutter/injection.dart';

class TopScreen extends HookConsumerWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(topViewModelProvider);
    final notifier = ref.read(topViewModelProvider.notifier);

    useEffect(() {
      // notifier.fetch();
      return null;
    }, const []);

    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Top Page',
        showBackButton: false,
      ),
      body: Center(
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends HookConsumerWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // onPressed as empty function
        _ButtonWidget(
            text: 'Subscription test',
            onPressed: () {
              Navigator.of(context).pushNamed('/subscription');
            },
        ),
        const SizedBox(height: 16.0),
        // _ButtonWidget(text: '', onPressed: null),
      ],
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final String text;
  final Function? onPressed;

  const _ButtonWidget({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed?.call(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        fixedSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white), // TODO theme 拡張に定義する
      ),
    );
  }
}
