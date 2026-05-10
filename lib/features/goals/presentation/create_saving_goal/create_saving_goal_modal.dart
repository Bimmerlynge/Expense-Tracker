import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button_inverted.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:expense_tracker/design_system/primitives/labelled_field.dart';
import 'package:expense_tracker/design_system/primitives/number_editable_field.dart';
import 'package:expense_tracker/design_system/primitives/text_editable_field.dart';
import 'package:expense_tracker/design_system/primitives/white_box.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/presentation/create_saving_goal/create_saving_goal_modal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSavingGoalModal extends ConsumerStatefulWidget {
  const CreateSavingGoalModal({super.key});

  @override
  ConsumerState<CreateSavingGoalModal> createState() => _CreateSavingGoalModalState();
}

class _CreateSavingGoalModalState extends ConsumerState<CreateSavingGoalModal> {
  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(createSavingGoalModalControllerProvider);
    final controller = ref.read(createSavingGoalModalControllerProvider.notifier);

    return AppAlertDialog(
        iconData: Icons.new_releases_outlined,
        title: "Nyt opsparingsmål",
        content: _content(controller, goal),
        actions: _actions(context, controller)
    );
  }

  Widget _content(CreateSavingGoalModalController controller, Goal goal) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _title(controller, goal),
        SizedBox(height: 12),
        _amount(controller, goal),
        SizedBox(height: 12),
        _billedUrl(controller, goal),
        SizedBox(height: 6),
        _sharedCheckBox(controller, goal)
      ],
    );
  }

  Widget _title(CreateSavingGoalModalController controller, Goal goal) {
    return LabelledField(
        label: "Titel",
        child: WhiteBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextEditableField(
                  textAlign: TextAlign.center,
                  initialValue: goal.title,
                  onValueChanged: (val) {
                    controller.updateTitle(val);
                  }
                      ),
            )
      )
    );
  }

  Widget _amount(CreateSavingGoalModalController controller, Goal goal) {
    return LabelledField(
        label: "Beløb",
        child: WhiteBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: NumberEditableField(
                  initialValue: goal.goalAmount,
                  onValueChanged: (val) {
                    controller.updateGoalAmount(val);
                  }
              ),
            )
        )
    );
  }

  Widget _billedUrl(CreateSavingGoalModalController controller, Goal goal) {
    return LabelledField(
        label: "Billed url",
        child: WhiteBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextEditableField(
                  initialValue: goal.uri ?? "",
                  onValueChanged: (val) {
                    controller.updateUri(val);
                  }
              ),
            )
        )
    );
  }

  Widget _sharedCheckBox(CreateSavingGoalModalController controller, Goal goal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Fælles opsparing', style: TextStyle(color: AppColors.primarySecondText),),
        Checkbox(
          value: goal.isShared,
          onChanged: (val) => controller.updateIsShared(!goal.isShared),
        ),
      ],
    );
  }

  Widget _actions(BuildContext context, CreateSavingGoalModalController controller) {
    return Row(
      children: [
        Expanded(
          child: PremiumBlueButtonInverted(
              height: 30,
              text: 'Tilbage',
              onTap: () => Navigator.of(context).pop(false)
          ),
        ),
        SizedBox(width: 16),
        Expanded(
            child: PremiumBlueButton(
              height: 30,
              text: 'Opret',
              onTap: () => _handleConfirm(controller),
              linearBegin: Alignment.topLeft,
              linearEnd: Alignment.bottomRight,
            )
        )
      ],
    );
  }

  Future<void> _handleConfirm(
      CreateSavingGoalModalController controller,
      ) async {
    final success = await controller.createSavingGoal();

    if (success) {
      ToastService.showSuccessToast('Nyt opsparingsmål oprettet!');

      if(mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastService.showErrorToast('Kunne ikke oprette nyt opsparingsmål');
    }
  }
}
