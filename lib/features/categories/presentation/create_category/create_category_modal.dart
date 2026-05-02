import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/app/shared/widgets/white_box.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button_inverted.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:expense_tracker/design_system/primitives/labelled_field.dart';
import 'package:expense_tracker/design_system/primitives/text_editable_field.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/create_category/create_category_modal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCategoryModal extends ConsumerStatefulWidget {
  const CreateCategoryModal({super.key});

  @override
  ConsumerState<CreateCategoryModal> createState() => _CreateCategoryModalState();
}

class _CreateCategoryModalState extends ConsumerState<CreateCategoryModal> {

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(createCategoryModalControllerProvider.notifier);
    final category = ref.watch(createCategoryModalControllerProvider);

    return AppAlertDialog(
        iconData: Icons.new_releases_outlined,
        title: "Ny kategori",
        content: _content(controller, category),
        actions: _actions(controller)
    );
  }

  Widget _content(CreateCategoryModalController controller, Category category) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _name(controller),
      ],
    );
  }

  Widget _name(CreateCategoryModalController controller) {
    return LabelledField(
        label: "Name",
        child: WhiteBox(
            borderRadius: 25,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextEditableField(
                  initialValue: "",
                  onValueChanged: (val) {
                    controller.updateName(val);
                  }
              ),
            )
        )
    );
  }

  Widget _actions(CreateCategoryModalController controller) {
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
              text: 'Opret',
              onTap: () => _onCreate(controller),
              linearBegin: Alignment.topLeft,
              linearEnd: Alignment.bottomRight,
            )
        )
      ],
    );
  }

  void _onCreate(CreateCategoryModalController controller) async {
    final success = await controller.createCategory();

    if (success) {
      ToastService.showSuccessToast('Kategori oprettet!');

      if(mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastService.showErrorToast('Fejl ved oprettelse af kategori.');
    }
  }
}
