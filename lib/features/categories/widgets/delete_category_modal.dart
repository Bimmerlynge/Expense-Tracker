import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button_inverted.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:flutter/material.dart';

class DeleteCategoryModal extends StatelessWidget {
  final Category category;
  final VoidCallback onDelete;

  const DeleteCategoryModal({
    super.key,
    required this.category,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
        iconData: Icons.info_outline_rounded,
        title: "Bekræft sletning",
        content: _content(),
        actions: _actions(context)
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Vil du slette denne kategori?', style: TextStyle(color: AppColors.secondary)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Navn', style: TextStyle(color: Colors.black87)),
            Text(category.name, style: TextStyle(color: Colors.black87))
          ],
        )
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PremiumBlueButtonInverted(
              height: 30,
              text: 'Fortryd',
              onTap: () => Navigator.of(context).pop(false)
          ),
        ),
        SizedBox(width: 16,),
        Expanded(
            child: PremiumBlueButton(
              height: 30,
              text: 'Slet',
              onTap: onDelete,
              linearBegin: Alignment.topLeft,
              linearEnd: Alignment.bottomRight,
            )
        )
      ],
    );
  }
}
