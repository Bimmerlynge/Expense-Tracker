import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopupWidget<T> extends ConsumerStatefulWidget {
  final double popupWidthScale;
  final Icon? popupIcon;
  final String? headerTitle;
  final Widget bodyContent;
  final Future<void> Function() onConfirm;
  final String confirmText;

  const PopupWidget({
    super.key,
    this.popupIcon,
    this.popupWidthScale = 0.9,
    this.headerTitle,
    required this.bodyContent,
    required this.onConfirm,
    required this.confirmText

  });

  @override
  ConsumerState<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends ConsumerState<PopupWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: widget.popupIcon,
      title: _buildHeader(),
      content: _buildContent(),
      actions: _buildActions(),
    );
  }

  Widget? _buildHeader() {
    if (widget.headerTitle == null) {
      return null;
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.headerTitle!),
          const SizedBox(height: 4),
          Divider(thickness: 1, color: AppColors.onPrimary),
        ]
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: widget.bodyContent,
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Tilbage',
              style: TextStyle(color: AppColors.onPrimary),
            ),
          ),
          TextButton(
            onPressed: () async => {
              await widget.onConfirm.call(),
              Navigator.of(context).pop(true),
            },
            child: Text(
              widget.confirmText,
              style: TextStyle(color: AppColors.primaryText),
            ),
          ),
        ],
      )
    ];
  }
}
