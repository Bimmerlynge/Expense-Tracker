import 'package:expense_tracker/app/shared/components/app_bar.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/amount_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/category_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/date_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/description_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/person_input.dart';
import 'package:expense_tracker/features/transactions/components/add_transaction_inputs/type_input.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen/add_transaction_screen_controller.dart';
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
  final GlobalKey _buttonKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _descriptionFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _descriptionFocusNode.addListener(() {
      if (_descriptionFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final buttonContext = _buttonKey.currentContext;
          if (buttonContext != null) {
            Scrollable.ensureVisible(
              buttonContext,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0.1,
            );
          }
        });
      } else {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: [
          TAppBar(innerBoxScrolled: true, title: "Ny Overførsel",),
          SliverFillRemaining(child: _buildForm())
        ]
      )
    );
  }

  Widget _buildForm() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 32,
                  left: 32,
                  bottom: 32
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildInputs()),
                    _buildButtons(),
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
        key: _buttonKey,
        onPressed: _isLoading
            ? null
            : () async {
                setState(() => _isLoading = true);
                await onAdd();
                setState(() => _isLoading = false);
              },
        child: _isLoading
            ? CircularProgressIndicator(strokeWidth: 2)
            : const Text('Tilføj'),
      ),
    );
  }

  Future<void> onAdd() async {
    final controller = ref.read(addTransactionScreenControllerProvider.notifier);

    var amount = ref.watch(selectedAmountProvider);
    var category = ref.watch(selectedCategoryProvider);
    var person = ref.watch(selectedPersonProvider);
    var type = ref.watch(selectedTypeProvider);
    var date = ref.watch(selectedDateProvider);
    // ignore: unused_local_variable
    var description = ref.watch(selectedDescriptionProvider);

    try {
      _descriptionFocusNode.unfocus();

      await controller.createTransaction(
        Transaction(
          user: person,
          amount: amount,
          category: category!,
          type: type,
          transactionTime: date,
          description: description
        ),
      );

      ref.read(selectedAmountProvider.notifier).state = 0.0;

      ToastService.showSuccessToast('Transaction was added!');
    } catch (e) {
      ToastService.showErrorToast('An error occurred trying to add transaction.');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
}
