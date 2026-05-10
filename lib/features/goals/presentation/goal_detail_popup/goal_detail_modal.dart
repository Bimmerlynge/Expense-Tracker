import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/image_widget.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button_inverted.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:expense_tracker/design_system/primitives/labelled_field.dart';
import 'package:expense_tracker/design_system/primitives/number_editable_field.dart';
import 'package:expense_tracker/design_system/primitives/text_editable_field.dart';
import 'package:expense_tracker/design_system/primitives/white_box.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/extensions/goal_extensions.dart';
import 'package:expense_tracker/features/goals/presentation/goal_detail_popup/goal_detail_modal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalDetailModal extends ConsumerStatefulWidget {
  final Goal goal;

  const GoalDetailModal({
    super.key,
    required this.goal
  });

  @override
  ConsumerState<GoalDetailModal> createState() => _GoalDetailModalState();
}

class _GoalDetailModalState extends ConsumerState<GoalDetailModal> {
  var _addAmount = 0.0;


  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(goalDetailModalControllerProvider(widget.goal));
    final controller = ref.read(goalDetailModalControllerProvider(widget.goal).notifier);

    return AppAlertDialog(
        iconData: Icons.edit_rounded,
        title: widget.goal.title,
        content: _content(controller, goal),
        contentPadding: 0,
        actions: _actions(controller)
    );
  }

  Widget _content(GoalDetailModalController controller, Goal goal) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _image(controller, goal),
        Divider(thickness: 1, color: AppColors.primaryText.withAlpha(40), height: 1),
        _amountSection(goal),
        Divider(thickness: 1, color: AppColors.primaryText.withAlpha(40), height: 1),
        _updateAmountSection(controller, goal),
        Divider(thickness: 1, color: AppColors.primaryText.withAlpha(40), height: 1),
        _setSharedRow(controller, goal),
      ],
    );
  }

  Widget _image(GoalDetailModalController controller, Goal goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ImageWidget(uri: goal.uri, height: 80, width: 80),
          SizedBox(width: 12),
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
                _uriInput(controller, goal),
            ],
          ))
        ],
      ),
    );
  }

  Widget _uriInput(GoalDetailModalController controller, Goal goal) {
    return LabelledField(
        label: "Billed url",
        child: WhiteBox(
          borderRadius: 4,
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

  Widget _amountSection(Goal goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_savedRow(goal), _progressRow(goal), _summaryRow(goal)],
      ),
    );
  }

  Widget _savedRow(Goal goal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${goal.currentAmount.toStringAsFixed(0)} opsparet', style: TextStyle(color: AppColors.primarySecondText)),
        Text('${goal.savedPercentage.toStringAsFixed(0)}% opsparet', style: TextStyle(color: AppColors.primarySecondText)),
      ],
    );
  }

  Widget _progressRow(Goal goal) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: widget.goal.savedPercentage / 100,
        minHeight: 8,
        backgroundColor: Colors.grey.shade300,
        color: AppColors.primary,
      ),
    );
  }

  Widget _summaryRow(Goal goal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${widget.goal.remaining.toStringAsFixed(0)} tilbage', style: TextStyle(color: AppColors.primarySecondText)),
        Text('${widget.goal.goalAmount.toStringAsFixed(0)} i alt', style: TextStyle(color: AppColors.primarySecondText)),
      ],
    );
  }

  Widget _updateAmountSection(GoalDetailModalController controller, Goal goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addAmountTitle(),
          SizedBox(height: 12),
          _addAmountInput(controller, goal)
        ],
      ),
    );
  }

  Widget _addAmountTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Tilføj beløb til opsparing',
        style: TextStyle(color: AppColors.primarySecondText, fontSize: 14),
      ),
    );
  }

  Widget _addAmountInput(GoalDetailModalController controller, Goal goal) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Text(
                'kr',
                style: TextStyle(
                  color: AppColors.whiter,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: BoxBorder.symmetric(
                    horizontal: BorderSide(color: AppColors.primary, width: 1)
                  )
                ),
                child: Center(
                  child: NumberEditableField(
                      initialValue: _addAmount,
                      onValueChanged: (val) {
                        setState(() {
                          _addAmount = val;
                        });
                      }
                  ),
                ),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _addAmount += 100;
                  });
                },
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    '+100',
                    style: TextStyle(
                      color: AppColors.whiter,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setSharedRow(GoalDetailModalController controller, Goal goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Del opsparingsmål', style: TextStyle(color: AppColors.primarySecondText)),
          Center(
            child: Toggle(
              value: goal.isShared,
              onToggled: (_) {
                controller.updateIsShared();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(GoalDetailModalController controller) {
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
              text: 'Gem',
              onTap: () => _handleConfirm(controller),
              linearBegin: Alignment.topLeft,
              linearEnd: Alignment.bottomRight,
            )
        )
      ],
    );
  }

  Future<void> _handleConfirm(GoalDetailModalController controller) async {
    controller.addToCurrent(_addAmount);

    final success = await controller.updateGoal();

    if (success) {
      ToastService.showSuccessToast('Opsparingsmål opdateret!');

      if(mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastService.showErrorToast('Kunne ikke opdatere opsparingsmålet');
    }
  }
}
