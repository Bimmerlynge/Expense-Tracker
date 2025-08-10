import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/text_input.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEntryForm extends ConsumerStatefulWidget {
  final void Function(Transaction) onSubmit;

  const AddEntryForm({super.key, required this.onSubmit});

  @override
  ConsumerState<AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends ConsumerState<AddEntryForm> {
  final _formKey = GlobalKey<FormState>();

  late Category _category;
  late double _amount;
  late Person _person;
  TransactionType _type = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    final combinedAsync = ref.watch(combinedHouseholdDataProvider);

    return combinedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (value) {
        final (categories, persons) = value;

        _person = ref.watch(currentUserProvider);

        return _buildAlertDialog(categories, persons);
      },
    );
  }

  AlertDialog _buildAlertDialog(
    List<Category> categories,
    List<Person> persons,
  ) {
    return AlertDialog(
      title: Column(children: [Text('Add transaction')]),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAmountInput(),
            _buildCategoryInput(categories),
            _buildTransactionTypeInput(),
            _buildPersonInput(persons),
            _buildDescriptionInput(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(onPressed: onSubmit, child: Text('Tilføj')),
      ],
    );
  }

  Column _buildAmountInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount'),
        Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(45),
          ),
          child: TextFormField(
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            onChanged: (val) => _amount = double.tryParse(val) ?? 0,
            validator: (val) =>
                val == null ||
                    double.tryParse(val) == null ||
                    double.parse(val) < 0
                ? 'Enter a valid amount'
                : null,
          ),
        ),
      ],
    );
  }

  DropdownButtonFormField _buildCategoryInput(List<Category> categories) {
    _category = categories.first;

    return DropdownButtonFormField<Category>(
      value: _category,
      items: categories
          .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
          .toList(),
      onChanged: (val) {
        if (val != null) _category = val;
      },
    );
  }

  DropdownButtonFormField _buildTransactionTypeInput() {
    return DropdownButtonFormField<TransactionType>(
      value: _type,
      items: TransactionType.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: (val) {
        if (val != null) setState(() => _type = val);
      },
    );
  }

  DropdownButtonFormField _buildPersonInput(List<Person> persons) {
    return DropdownButtonFormField<Person>(
      value: ref.watch(currentUserProvider),
      onChanged: (value) {
        _person = value as Person;
      },
      items: persons
          .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
          .toList(),
      decoration: InputDecoration(labelText: 'Select Person'),
    );
  }

  TextFormField _buildDescriptionInput() {
    return TextFormField(decoration: InputDecoration(labelText: "Description"));
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(
        Transaction(
          user: _person,
          amount: _amount,
          category: _category,
          type: _type,
        ),
      );

      FocusScope.of(context).unfocus();
    }
  }
}
