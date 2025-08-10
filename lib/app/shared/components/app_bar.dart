import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String title;

  const TAppBar({super.key, this.title = ''});

  @override
  ConsumerState<TAppBar> createState() => _TAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TAppBarState extends ConsumerState<TAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      elevation: 0,
      actions: [],
    );
  }
}
