import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/app_bar.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/amount_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/category_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/date_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/description_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/person_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/type_input.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _descriptionFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: 'Add Transaction'),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Expanded(child: _buildInputs()),
                    _buildButtons(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputs() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AmountInput(),
        DateInput(),
        CategoryInput(),
        PersonInput(),
        TypeInput(),
        DescriptionInput(focusNode: _descriptionFocusNode),
      ],
    );
  }

  Widget _buildButtons() {
    return Align(
      alignment: Alignment.center,
      child: OutlinedButton(
        onPressed: _isLoading
            ? null
            : () async {
                setState(() => _isLoading = true);
                await onAdd();
                setState(() => _isLoading = false);
              },
        child: _isLoading
            ? CircularProgressIndicator(strokeWidth: 2)
            : const Text('Add'),
      ),
    );
  }

  Future<void> onAdd() async {
    final viewModel = ref.read(transactionViewModelProvider.notifier);

    var amount = ref.watch(selectedAmountProvider);
    var category = ref.watch(selectedCategoryProvider);
    var person = ref.watch(selectedPersonProvider);
    var type = ref.watch(selectedTypeProvider);
    var date = ref.watch(selectedDateProvider);
    // ignore: unused_local_variable
    var description = ref.watch(selectedDescriptionProvider);

    try {
      await viewModel.addTransaction(
        Transaction(
          user: person,
          amount: amount,
          category: category!,
          type: type,
          transactionTime: date
        ),
      );

      if (!mounted) return;
      ToastService.showSuccessToast(context, 'Transaction was added!');
    } catch (e) {
      if (!mounted) return;
      ToastService.showErrorToast(
        context,
        'An error occurred trying to add transaction.',
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
}
