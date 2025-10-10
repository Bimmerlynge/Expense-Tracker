import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/create_category/create_category_popup_controller.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCategoryPopup extends ConsumerStatefulWidget {
  const CreateCategoryPopup({super.key});

  @override
  ConsumerState<CreateCategoryPopup> createState() => _CreateCategoryPopupState();
}

class _CreateCategoryPopupState extends ConsumerState<CreateCategoryPopup> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(createCategoryPopupControllerProvider.notifier);
    final category = ref.watch(createCategoryPopupControllerProvider);

    return PopupWidget(
        popupIcon: const Icon(Icons.new_releases_outlined),
        bodyContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            _buildTitleRow(controller, category)
            ]
        ),
        onConfirm: () => _handleConfirm(controller),
        confirmText: "Opret",
        headerTitle: "Ny kategori",
    );
  }

  Future<void> _handleConfirm(CreateCategoryPopupController controller) async {
    final success = await controller.createCategory();

    if (success) {
      ToastService.showSuccessToast('Ny kategori oprettet!');
    } else {
      ToastService.showErrorToast('Kunne ikke oprette ny kategori');
    }
  }

  Widget _buildTitleRow(CreateCategoryPopupController controller, Category category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Navn'),
        ),
        inputContainer(
          TextFormField(
            initialValue: category.name,
            style: TextStyle(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
            onChanged: controller.updateName,
          ),
        ),
      ],
    );
  }
}
