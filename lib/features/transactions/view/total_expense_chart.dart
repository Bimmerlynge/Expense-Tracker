// import 'package:expense_tracker/app/network/dio_api_client.dart';
// import 'package:expense_tracker/app/network/mock/mock_dio_setup.dart';
// import 'package:expense_tracker/features/transactions/components/total_bar_chart.dart';
// import 'package:expense_tracker/features/transactions/components/total_bar_hori_chart.dart';
// import 'package:expense_tracker/features/transactions/components/total_pie_chart.dart';
// import 'package:expense_tracker/features/transactions/service/transaction_service.dart';
// import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class TotalExpenseChart extends StatefulWidget {
//   const TotalExpenseChart({super.key});
//
//   @override
//   State<TotalExpenseChart> createState() => _TotalExpenseChartState();
// }
//
// class _TotalExpenseChartState extends State<TotalExpenseChart> {
//   late final TransactionViewModel viewModel;
//   late List<CategorySpending> _categorySpendingList = [];
//   bool _showPieChart = true;
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel = TransactionViewModel(TransactionService(DioApiClient(dio)));
//     loadTransactions();
//
//   }
//
//   Future<void> loadTransactions() async {
//     await viewModel.loadTransactions();
//     setState(() {
//       _categorySpendingList = viewModel.getCategorySpendingList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_categorySpendingList.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return Stack(
//       children: [
//         Center(
//           child: _showPieChart
//               ? TotalPieChart(categorySpendingList: _categorySpendingList)
//               : TotalBarChart(categorySpendingList: _categorySpendingList)
//         ),
//         Positioned(
//           bottom: 16,
//           left: 16,
//           child: Row(
//             children: [
//               const Text("Pie"),
//               Switch(
//                 value: !_showPieChart,
//                 onChanged: (val) {
//                   setState(() {
//                     _showPieChart = !val;
//                   });
//                 },
//               ),
//               const Text("Bar"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
