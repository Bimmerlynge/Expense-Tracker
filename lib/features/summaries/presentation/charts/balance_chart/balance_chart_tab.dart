import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/summaries/domain/balance_total.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/balance_chart/balance_pie_chart.dart';
import 'package:expense_tracker/features/summaries/providers/balance_totals_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceChartTab extends ConsumerStatefulWidget {
  const BalanceChartTab({super.key});

  @override
  ConsumerState<BalanceChartTab> createState() => _BalanceChartTabState();
}

class _BalanceChartTabState extends ConsumerState<BalanceChartTab> {

  @override
  Widget build(BuildContext context) {
    return _buildCharts();
  }

  Widget _buildCharts() {
    final persons = ref.watch(personListProvider);
    final currentUser = ref.read(currentUserProvider);

    if (persons.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final sortedPersons = List<Person>.from(persons)
      ..sort((a, b) {
        if (a.id == currentUser.id) return -1;
        if (b.id == currentUser.id) return 1;
        return 0;
      });


    return Column(
      children: [
        for (int i = 0; i < sortedPersons.length; i++) ...[
          _buildChart(sortedPersons[i]),
          if (i < persons.length - 1) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(color: AppColors.primaryText.withAlpha(80),),
          ),
        ]
      ],
    );
  }

  Widget _buildChart(Person person) {
    final balanceTotals = ref.watch(balanceTotalsListProvider);

    if (balanceTotals.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final balanceTotal = balanceTotals.firstWhere((b) => b.person.id == person.id);

    return Expanded(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 32,),
            _name(person.name),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  _incomeTotal(balanceTotal),
                  Expanded(child: _chart(balanceTotal)),
                  _expenseTotal(balanceTotal),
                  SizedBox(width: 12,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  
  Widget _name(String name) {
    return Text(name, style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w400),);
  }
  
  Widget _incomeTotal(BalanceTotal balanceTotal) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      // color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: Colors.green.withAlpha(30),
            ),
            padding: EdgeInsets.all(6),
            child: Icon(Icons.arrow_downward_outlined, color: Colors.green,),
          ),
          SizedBox(height: 6,),
          Text('Indkomst'),
          Text('${balanceTotal.income.toStringAsFixed(2)} kr', style: TextStyle(color: Colors.green),)
        ],
      ),
    );
  }
  
  Widget _expenseTotal(BalanceTotal balanceTotal) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12)
      ),
      // color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: Colors.red.withAlpha(30),
            ),
            padding: EdgeInsets.all(6),
            child: Icon(Icons.arrow_upward_outlined, color: Colors.red,),
          ),
          SizedBox(height: 6,),
          Text('Udgift'),
          Text('${balanceTotal.expense.toStringAsFixed(2)} kr', style: TextStyle(color: Colors.red),)
        ],
      ),
    );
  }

  Widget _chart(BalanceTotal balanceTotal) {
    return BalancePieChart(balanceTotal: balanceTotal);
  }

}
