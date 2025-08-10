import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/radio_button.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonInput extends ConsumerWidget {
  const PersonInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personsAsync = ref.watch(personStreamProvider);
    final selectedPerson = ref.watch(selectedPersonProvider);
    final selectedPersonNotifier = ref.read(selectedPersonProvider.notifier);

    return personsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error loading persons: $e'),
      data: (persons) {
        if (persons.isEmpty) {
          return const Text('No persons available');
        }

        final twoPersons = persons.take(2).toList();

        return Row(
          children: [
            Expanded(
              child: RadioButton<Person>(
                value: twoPersons[0],
                onSelected: (value) => selectedPersonNotifier.state = value,
                selectedValue: selectedPerson,
                child: Text(twoPersons[0].name),
              ),
            ),
            if (twoPersons.length > 1) SizedBox(width: 16),
            if (twoPersons.length > 1)
              Expanded(
                child: RadioButton<Person>(
                  value: twoPersons[1],
                  onSelected: (value) => selectedPersonNotifier.state = value,
                  selectedValue: selectedPerson,
                  child: Text(twoPersons[1].name),
                ),
              ),
          ],
        );
      },
    );
  }
}
