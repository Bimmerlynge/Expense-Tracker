import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmountInput extends ConsumerStatefulWidget {
  const AmountInput({super.key});

  @override
  ConsumerState<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends ConsumerState<AmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialAmount = ref.read(selectedAmountProvider);
    _controller = TextEditingController(text: initialAmount.toString());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<double>(selectedAmountProvider, (previous, next) {
      final textValue = double.tryParse(_controller.text) ?? 0.0;
      if (textValue != next) {
        _controller.text = next.toString();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Beløb', style: TextStyle(color: AppColors.primaryText)),
        ),
        inputContainer(
          TextFormField(
            controller: _controller,
            onChanged: (value) {
              final parsed = parseInput(value);
              ref.read(selectedAmountProvider.notifier).state = parsed;
            },
            style: TextStyle(color: AppColors.onPrimary),
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
        ),
      ],
    );
  }

  double parseInput(String inputValue) {
    final dotFormat = inputValue.replaceAll(",", ".");
    if (dotFormat.isEmpty) return 0.0;
    return double.tryParse(dotFormat) ?? 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
