import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/shared/widgets/white_box.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_screen_controller.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/date_input.dart';
import 'package:expense_tracker/features/transactions/domain/receipt.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/line_item_tile.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/receipt_date_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceiptWidget extends ConsumerStatefulWidget {
  final Receipt receipt;

  const ReceiptWidget({super.key, required this.receipt});

  @override
  ConsumerState<ReceiptWidget> createState() => _ReceiptWidgetState();
}

class _ReceiptWidgetState extends ConsumerState<ReceiptWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 12, left: 8, right: 8),
        child: WhiteBox(child: _receiptBody())
    );
  }

  Widget _receiptBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ReceiptDateRow(initialDate: widget.receipt.date, onDateChanged: (_){}),
            Divider(),
            if (widget.receipt.unresolvedDiscounts.isNotEmpty) ...{
              _discountListRow(),
              Divider()
            },
            _itemListRow()
      
          ],
        ),
      ),
    );
  }

  Widget _itemListRow() {
    final categoriesAsync = ref.watch(categoryListScreenControllerProvider);

    return AsyncValueWidget(
      value: categoriesAsync,
      data: (categories) => Column(
        children: [
          _addItem(),
          ...widget.receipt.items.map((item) {
            return LineItemTile(item: item, categories: categories, undeterminedDiscounts: widget.receipt.unresolvedDiscounts);
          })
        ],
      )
    );
  }

  Widget _addItem() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Scannede varer', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                Text('Tilføj vare', style: TextStyle(color: AppColors.onPrimary)),
                SizedBox(width: 12)
              ],
            )
          ],
        ),
        Divider()
      ],
    );
  }

  Widget _discountListRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rabatter', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                Text('Tilføj rabat', style: TextStyle(color: AppColors.onPrimary),),
                SizedBox(width: 12,)
              ],
            )
          ],
        ),
        discountList(),
      ],
    );
  }

  Widget discountList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300)
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          ...widget.receipt.unresolvedDiscounts.map((discount) {
            final isApplied = discount.appliedTo != null;

            return Stack(
              alignment: Alignment.center,
              children: [
                if (isApplied) ...{
                  Divider(color: Colors.black87,),
                },
                Opacity(
                opacity: discount.appliedTo != null ? 0.4 : 1,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(discount.id.toString()),
                      Text(discount.name),
                      Text(discount.amount.toStringAsFixed(2)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                    ]),
              ),

            ]
            );
          })
        ],
      ),
    );
  }
}
