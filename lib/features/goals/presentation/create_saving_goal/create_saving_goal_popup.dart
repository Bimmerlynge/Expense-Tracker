import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:expense_tracker/features/goals/application/goal_service.dart';
import 'package:expense_tracker/features/goals/presentation/create_saving_goal/create_saving_goal_popup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSavingGoalPopup extends ConsumerStatefulWidget {
  const CreateSavingGoalPopup({super.key});

  @override
  ConsumerState<CreateSavingGoalPopup> createState() => _CreateSavingGoalPopupState();
}

class _CreateSavingGoalPopupState extends ConsumerState<CreateSavingGoalPopup> {

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(createSavingGoalPopupControllerProvider.notifier);
    final goal = ref.watch(createSavingGoalPopupControllerProvider);

    return PopupWidget(
        popupIcon: const Icon(Icons.new_releases_outlined),
        bodyContent: _buildBody(controller, goal),
        onConfirm: () => _handleConfirm(controller),
        confirmText: "Opret",
        headerTitle: "Nyt opsparingsmål",
    );
  }

  Column _buildBody(CreateSavingGoalPopupController controller, Goal goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleRow(controller, goal),
        const SizedBox(height: 16),
        _buildAmountRow(controller, goal),
        const SizedBox(height: 16),
        _buildUriRow(controller, goal),
        const SizedBox(height: 16),
        _buildIsSharedRow(controller, goal),

      ],
    );
  }

  Future<void> _handleConfirm(CreateSavingGoalPopupController controller) async {
    final success = await controller.createSavingGoal();

    if (success) {
      ToastService.showSuccessToast('Nyt opsparingsmål oprettet!');
      ref.read(goalServiceProvider).getGoalsStream();
    } else {
      ToastService.showErrorToast('Kunne ikke oprette nyt opsparingsmål');
    }
  }

  Widget _buildTitleRow(CreateSavingGoalPopupController controller, Goal goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Titel'),
        ),
        inputContainer(
          TextFormField(
            initialValue: goal.title,
            style: TextStyle(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
            onChanged: controller.updateTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(CreateSavingGoalPopupController controller, Goal goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Beløb'),
        ),
        inputContainer(
          TextFormField(
            initialValue: goal.goalAmount.toString(),
            style: TextStyle(color: AppColors.onPrimary),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            onChanged: (val) => controller.updateGoalAmount(double.tryParse(val) ?? 0),
          ),
        ),
      ],
    );
  }

  Widget _buildIsSharedRow(CreateSavingGoalPopupController controller, Goal goal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Fælles opsparing'),
        Checkbox(
            value: goal.isShared,
            onChanged: (val) => controller.updateIsShared(!goal.isShared))
      ],
    );
  }

  Widget _buildUriRow(CreateSavingGoalPopupController controller, Goal goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Billed url'),
        ),
        inputContainer(
          TextFormField(
            initialValue: goal.uri,
            style: TextStyle(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
            onChanged: controller.updateUri,
          ),
        ),
      ],
    );
  }
}
