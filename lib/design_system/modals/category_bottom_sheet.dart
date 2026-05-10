import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryBottomSheet extends ConsumerWidget {
  final List<String> categories;
  final List<String> excludedCategories;
  final Function(List<String>) onUpdated;

  const CategoryBottomSheet({
    super.key,
    required this.categories,
    required this.excludedCategories,
    required this.onUpdated
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiter,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dragHandle(),
                const SizedBox(height: 16),
                _title(),
                const SizedBox(height: 8),
                Divider(color: AppColors.primaryText,),
                const SizedBox(height: 12),
                _chips(ref, categories, excludedCategories)
              ],
            ),
          )
      ),
    );
  }

  Widget _chips(
      WidgetRef ref,
      List<String> categories,
      List<String> excludedCategories,
      ) {
    return Wrap(
      spacing: 14,
      runSpacing: 16,
      children: categories.map((category) {

        final isSelected = !excludedCategories.contains(category);

        return _chip(
          categoryName: category,
          selected: isSelected,
          onTap: () {

            final updatedExcluded = [...excludedCategories];

            if (isSelected) {
              updatedExcluded.add(category);
            } else {
              updatedExcluded.remove(category);
            }

            onUpdated(updatedExcluded);
          },
        );
      }).toList(),
    );
  }

  Widget _chip({
    required String categoryName,
    required bool selected,
    required VoidCallback onTap,
  }) {

    final foregroundColor = selected
        ? AppColors.whiter
        : AppColors.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  : AppColors.whiter,

              borderRadius: BorderRadius.circular(4),

              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withAlpha(40),
                width: 1.2,
              ),

              boxShadow: selected
                  ? [
                BoxShadow(
                  color: AppColors.primary.withAlpha(40),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
                  : [],
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Icon(
                  selected
                      ? Icons.check_rounded
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: foregroundColor,
                ),

                const SizedBox(width: 10),

                Text(
                  categoryName,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dragHandle() {
    return Container(
      width: 50,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _title() {
    return Text(
      'Viste kategorier',
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    );
  }
}
