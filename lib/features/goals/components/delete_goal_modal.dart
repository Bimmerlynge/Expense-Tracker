import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button_inverted.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:flutter/material.dart';

class DeleteGoalModal extends StatelessWidget {
  final Goal goal;
  final VoidCallback onConfirm;

  const DeleteGoalModal({
    super.key,
    required this.goal,
    required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
        iconData: Icons.info_outline,
        title: "Bekræft sletning",
        content: _content(),
        actions: _actions(context)
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Vil du slette dette opsparingsmål?',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.primary)),
        SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Titel',
              style: TextStyle(
                color: AppColors.primarySecondText
              ),
            ),
            Text(
              goal.title,
              style: TextStyle(
                color: AppColors.primarySecondText
              ),
            )
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
              onTap: onConfirm,
              linearBegin: Alignment.topLeft,
              linearEnd: Alignment.bottomRight,
            )
        )
      ],
    );
  }
}
