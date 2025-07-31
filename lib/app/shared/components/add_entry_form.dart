import 'package:dio/dio.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/text_input.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/mock/mock_dio_setup.dart';

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
  TransactionType _type = TransactionType.expense;
  late Person _person;

  @override
  Widget build(BuildContext context) {
    final combinedAsync = ref.watch(combinedHouseholdDataProvider);

    return combinedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (value) {
        final (categories, persons) = value;

        _category = categories.first;
        _person = ref.watch(currentUserProvider);

        return AlertDialog(
          title: Text('Add transaction'),
          content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                      onChanged: (val) => _amount = double.tryParse(val) ?? 0,
                      validator: (val) => val == null
                          || double.tryParse(val) == null
                          || double.parse(val) < 0 ? 'Enter a valid amount' : null
                  ),
                  DropdownButtonFormField<Category>(
                    value: _category,
                      items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                      onChanged: (val) {
                        if (val != null) _category = val;
                      }
                  ),
                  DropdownButtonFormField<TransactionType>(
                      value: _type,
                      items: TransactionType.values
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _type = val);
                      }),
                  DropdownButtonFormField<Person>(
                    value: ref.watch(currentUserProvider),
                    onChanged: (value) {
                      _person = value as Person;
                    },
                    items: persons.map((p) => DropdownMenuItem(
                      value: p, child: Text(p.name))
                    ).toList(),
                    decoration: InputDecoration(labelText: 'Select Person'),
                  ),
                  TextInput(label: "Description",)
                ],
              )
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel')
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(Transaction(
                        user: _person,
                        amount: _amount,
                        category: _category,
                        type: _type)
                    );
                  }
                },
                child: Text('Tilføj')
            )
          ],
        );

    });
  }
}
