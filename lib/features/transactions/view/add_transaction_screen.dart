import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/app_bar.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/amount_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/category_input.dart';
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

  @override
  void initState() {
    super.initState();

    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        print('no focus');
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: 'Add Transaction'),
      body: SingleChildScrollView(
        controller: _scrollController,
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 7, child: _buildInputs()),
          Expanded(flex: 3, child: _buildButtons()),
        ],
      ),
    );
  }

  Widget _buildInputs() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AmountInput(),
          CategoryInput(),
          PersonInput(),
          TypeInput(),
          DescriptionInput(focusNode: _descriptionFocusNode),
        ],
      ),
    );
  }

  Widget _buildAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Amount'),
        ),
        inputContainer(TextFormField(decoration: const InputDecoration())),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Description'),
          ),
          inputContainer(TextFormField(decoration: const InputDecoration())),
        ],
      ),
    );
  }

  bool _isLoading = false;

  Widget _buildButtons() {
    return Align(
      alignment: Alignment.center,
      child: OutlinedButton(
        onPressed: _isLoading ? null : () async {
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
    var category = ref.watch(selectedCategory);
    var person = ref.watch(selectedPersonProvider);
    var type = ref.watch(selectedTypeProvider);
    var description = ref.watch(selectedDescriptionProvider);


    try {
      await viewModel.addTransaction(
        Transaction(
          user: person,
          amount: amount,
          category: category!,
          type: type,
        ),
      );

      ToastService.showSuccessToast(context, 'Transaction was added!');
    } catch (e) {
      ToastService.showErrorToast(context, 'An error occurred trying to add transaction.');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
}
