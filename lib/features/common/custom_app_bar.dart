import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_2024_flutter/shared/extension/theme_extension.dart';

class CustomAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AppBar(
      title: Center(
        child: Text(
          title,
          style: theme.textTheme.appBarTitle(color: theme.appBarTitle),
        ),
      ),
      backgroundColor: Theme.of(context).appBarBackground,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.appBarTitle,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      actions: [
        SizedBox(
          width: showBackButton ? 48 : 0, // adjust width accordingly
        ),
      ],
    );
  }
}
