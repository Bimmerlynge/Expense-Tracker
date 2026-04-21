import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/radio_button.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:expense_tracker/features/users/providers/household_users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonInputRow extends ConsumerWidget {
  final ValueChanged<Person> onChanged;

  const PersonInputRow({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persons = ref.watch(householdUsersProvider);
    final selectedPerson = ref.watch(selectedPersonProvider);
    final selectedPersonNotifier = ref.read(selectedPersonProvider.notifier);

    if (persons.isEmpty) {
      return Container();
    }

    return Row(
      children: [
        Expanded(
          child: RadioButton<Person>(
            value: persons[0],
            onSelected: (value) {
              selectedPersonNotifier.state = value;
              onChanged.call(value);
            },
            selectedValue: selectedPerson,
            child: Text(persons[0].name),
          ),
        ),
        if (persons.length > 1) SizedBox(width: 16),
        if (persons.length > 1)
          Expanded(
            child: RadioButton<Person>(
              value: persons[1],
              onSelected: (value) {
                selectedPersonNotifier.state = value;
                onChanged.call(value);
              },
              selectedValue: selectedPerson,
              child: Text(persons[1].name),
            ),
          ),
      ],
    );


  }
}