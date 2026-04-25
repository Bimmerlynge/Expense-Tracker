import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/number_editable_field.dart';
import 'package:expense_tracker/app/shared/widgets/gray_box.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_screen_controller.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/category_input.dart';
import 'package:expense_tracker/features/transactions/domain/discount_item.dart';
import 'package:expense_tracker/features/transactions/domain/line_item.dart';
import 'package:expense_tracker/app/shared/components/t_dropdown.dart';
import 'package:expense_tracker/features/transactions/presentation/receipt_review_screen/receipt_review_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineItemTile extends ConsumerStatefulWidget {
  final LineItem item;
  final List<Category> categories;
  final List<DiscountItem> undeterminedDiscounts;
  final void Function(int) onDeleteItem;

  const LineItemTile({
    super.key,
    required this.item,
    required this.categories,
    required this.undeterminedDiscounts,
    required this.onDeleteItem
  });

  @override
  ConsumerState<LineItemTile> createState() => _LineItemTileState();
}

class _LineItemTileState extends ConsumerState<LineItemTile> {
  late Category _selectedCategory;

  static final _noDiscountObject = DiscountItem.nullObject();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.item.category!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.item.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            )),
        Row(
          children: [
            _price(),
            SizedBox(width: 12),
            Expanded(child: _category()),
            SizedBox(width: 12),
            Flexible(
                flex: 1,
                child: _discount()),
            _delete()
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _price() {
    return GrayBox(
      alignment: Alignment.center,
      width: 75,
      height: 40,
      child: NumberEditableField(
          initialValue: widget.item.price,
          onValueChanged: updateItemPrice,
      ),
    );
  }

  void updateItemPrice(double value) {
    widget.item.price = value;
  }

  Widget _category() {
    return GrayBox(
        height: 40,
        alignment: Alignment.center,
        child: TDropdown<Category>(
          iconSize: 0,
          value: _selectedCategory,
          items: widget.categories,
          label: (item) => item.name,
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue;
              widget.item.category = newValue;
            });
          },

        ),
    );
  }

  Widget _discount() {
    final noDiscountObject = DiscountItem.nullObject();
    return GrayBox(
        alignment: Alignment.center,
        child: TDropdown<DiscountItem>(
          items: [
            _noDiscountObject,
            ...widget.undeterminedDiscounts
          ],
          value: _getLineItemDiscountState(),
          onChanged: _onRabatSelected,
          label: (discount) =>
            discount.id >= 0
                ? "${discount.id} - ${discount.name}"
                : discount.name

      )
    );
  }

  DiscountItem _getLineItemDiscountState() {
    return ref.read(receiptReviewScreenControllerProvider.notifier).getLineItemDiscountState(widget.item);
  }

  void _onRabatSelected(DiscountItem discount) {
    ref.read(receiptReviewScreenControllerProvider.notifier).update(discount, widget.item);
  }

  Widget _delete() {
    return IconButton(onPressed: () => widget.onDeleteItem.call(widget.item.id!), icon: Icon(Icons.delete));
  }
}
