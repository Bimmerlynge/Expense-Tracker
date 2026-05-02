import 'package:expense_tracker/design_system/primitives/labelled_field.dart';
import 'package:expense_tracker/app/shared/components/t_dropdown.dart';
import 'package:expense_tracker/app/shared/widgets/gray_box.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/providers/default_category_provider.dart';
import 'package:expense_tracker/features/categories/providers/household_categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryInputRow extends ConsumerStatefulWidget {
  final Category initialValue;
  final ValueChanged<Category> onCategoryChanged;

  const CategoryInputRow({
    super.key,
    required this.initialValue,
    required this.onCategoryChanged,
  });

  @override
  ConsumerState<CategoryInputRow> createState() => _CategoryInputRowState();
}

class _CategoryInputRowState extends ConsumerState<CategoryInputRow> {

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(householdCategoriesProvider);

    return LabelledField(
        label: "Kategori", 
        child: GrayBox(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TDropdown<Category>(
                  fontSize: 16,
                  textAlign: Alignment.centerLeft,
                  icon: Icon(Icons.arrow_drop_down),
                  items: categories,
                  value: widget.initialValue,
                  onChanged: (newValue) => {
                    // setState(() {
                    //   _selectedCategory = newValue;
                    // }),
                    widget.onCategoryChanged.call(newValue)
                  },
                  label: (c) => c.name
              ),
            )
        )
    );
  }
}
