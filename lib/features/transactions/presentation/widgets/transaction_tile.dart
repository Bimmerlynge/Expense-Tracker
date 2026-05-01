import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/extensions/date_utils_extensions.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          _typeIcon(),
          SizedBox(width: 12),
          _category(),
          SizedBox(width: 12),
          Expanded(child: _infoColumn()),
          SizedBox(width: 8),
          _amount()
        ],
      ),
    );
  }

  Widget _typeIcon() {
    final type = transaction.type;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        color: type == TransactionType.expense
            ? Colors.red.withAlpha(25)
            : Colors.green.withAlpha(25)
      ),
      child: Icon(
        type == TransactionType.expense
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: type == TransactionType.expense
            ? Colors.red
            : Colors.green,
      ),
    );
  }

  Widget _category() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primary.withAlpha(15)
      ),
      child: Icon(
        Icons.favorite_border,
        color: AppColors.primary,
      ),
    );
  }

  Widget _infoColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        _date(),
        _user()
      ],
    );
  }

  Widget _title() {
    return Text(
      transaction.description == null || transaction.description!.isEmpty
          ? transaction.category.name
          : '${transaction.category.name} - ${transaction.description}',
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        fontSize: 12
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _date() {
    return Text(
        transaction.transactionTime!.formatDate(),
        style: TextStyle(
          color: AppColors.secondary,
          fontSize: 11,
          height: 1.1
        ),
    );
  }

  Widget _user() {
    return Text(
      transaction.user.name,
      style: TextStyle(
          color: AppColors.secondary,
          fontSize: 11,
          height: 1.1
      ),
    );
  }


  Widget _amount() {
    return Text(
      '${transaction.amount.toStringAsFixed(2)} kr',
      textAlign: TextAlign.right,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          color: transaction.type == TransactionType.expense
                  ? Colors.red
                  : Colors.green
      )
    );
  }
}
