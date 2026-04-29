import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/widgets/premium_blue.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:flutter/material.dart';

class NewUpdateModal extends StatelessWidget {
  final VoidCallback onDownload;

  const NewUpdateModal({super.key, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      iconData: Icons.cloud_download,
      title: "Ny Opdatering!",
      content: const Text(
        'En ny opdatering er tilgængelig. Installation påkrævet.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.primarySecondText),
      ),
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PremiumBlueButton(
                text: "Download",
                onTap: () => onDownload.call()
            ),
          )
        ],
      ),
    );
  }
}
