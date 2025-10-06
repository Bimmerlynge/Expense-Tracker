import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/create_category/create_category_popup_controller.dart';
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

    return AlertDialog(
      icon: const Icon(Icons.new_releases_outlined),
      title: _buildTitle(),
      content: _buildDialogContent(controller, category),
      actions: _buildActions(controller),
    );
  }

  Widget _buildTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Ny kategori'),
        const SizedBox(height: 8),
        Divider(thickness: 1, color: AppColors.onPrimary)
      ]
    );
  }

  Widget _buildDialogContent(CreateCategoryPopupController controller, Category category) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitleRow(controller, category),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(CreateCategoryPopupController controller) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(false),
              child: Text(
                'Afbryd',
                style: TextStyle(color: AppColors.onPrimary.withAlpha(200))
              )
          ),
          TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                setState(() => isLoading = true);
                final success = await controller.createCategory();
                setState(() => isLoading = false);

                if (success) {
                  ToastService.showSuccessToast('Ny kategori oprettet!');
                  Navigator.of(context).pop(true);
                } else {
                  ToastService.showErrorToast('Kunne ikke oprette ny kategori');
                }
              },
              child: isLoading
                ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text('Opret', style: TextStyle(color: AppColors.primaryText))
          )
        ]
      )
    ];
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
