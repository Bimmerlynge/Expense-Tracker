import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/transactions/presentation/transaction_list/transaction_list_screen.dart';
import 'package:flutter/cupertino.dart';

class TransactionListSection extends TabPageSection {
  TransactionListSection():
      super(
        body: TransactionListScreen(),
        header: Align(
            alignment: Alignment.centerLeft,
            child: HeaderTitle(
                title: 'Transaktioner denne måned')
        )
      );
}