import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/widgets.dart';
import 'interest_provider.dart';

class InterestCalculatorScreen extends ConsumerWidget {
  const InterestCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interestProvider);
    final notifier = ref.read(interestProvider.notifier);

    return CalculatorTemplate(
      title: 'Interest Calculator',
      icon: Icons.trending_up,
      inputSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<InterestType>(
            segments: const [
              ButtonSegment(value: InterestType.simple, label: Text('Simple')),
              ButtonSegment(
                value: InterestType.compound,
                label: Text('Compound'),
              ),
            ],
            selected: {state.type},
            onSelectionChanged: (value) => notifier.setType(value.first),
          ),
          const SizedBox(height: 24),
          NumericInputField(
            label: 'Principal Amount',
            prefix: '\u20B9 ',
            initialValue: state.principal,
            onChanged: (value) {
              if (value != null) notifier.setPrincipal(value);
            },
          ),
          const SizedBox(height: 16),
          LabeledSlider(
            label: 'Annual Interest Rate',
            value: state.rate,
            min: 1,
            max: 30,
            divisions: 290,
            suffix: '%',
            onChanged: notifier.setRate,
          ),
          const SizedBox(height: 16),
          LabeledSlider(
            label: 'Time Period',
            value: state.years.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            suffix: ' years',
            onChanged: (v) => notifier.setYears(v.round()),
          ),
          if (state.type == InterestType.compound) ...[
            const SizedBox(height: 16),
            _FrequencySelector(
              value: state.compoundingFrequency,
              onChanged: notifier.setCompoundingFrequency,
            ),
          ],
        ],
      ),
      resultsSection: Column(
        children: [
          ResultCard(
            title: 'Total Interest',
            value: CalculatorTemplate.formatCurrency(
              state.result?.interest ?? 0,
            ),
            icon: Icons.attach_money,
            valueColor: Colors.green,
          ),
          const SizedBox(height: 12),
          ResultCard(
            title: 'Total Amount',
            value: CalculatorTemplate.formatCurrency(
              state.result?.totalAmount ?? 0,
            ),
            icon: Icons.account_balance_wallet,
            valueColor: Theme.of(context).colorScheme.primary,
          ),
          if (state.type == InterestType.compound &&
              state.result?.effectiveRate != null) ...[
            const SizedBox(height: 12),
            ResultCard(
              title: 'Effective Annual Rate',
              value: '${state.result!.effectiveRate!.toStringAsFixed(2)}%',
              icon: Icons.percent,
              valueColor: Colors.orange,
            ),
          ],
        ],
      ),
      onReset: notifier.reset,
    );
  }
}

class _FrequencySelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _FrequencySelector({required this.value, required this.onChanged});

  static const _frequencies = [
    (1, 'Annually'),
    (2, 'Semi-Annually'),
    (4, 'Quarterly'),
    (12, 'Monthly'),
    (52, 'Weekly'),
    (365, 'Daily'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compounding Frequency',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _frequencies.map((f) {
            final selected = value == f.$1;
            return ChoiceChip(
              label: Text(f.$2),
              selected: selected,
              onSelected: (_) => onChanged(f.$1),
            );
          }).toList(),
        ),
      ],
    );
  }
}
