import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/widgets.dart';
import 'emi_provider.dart';

class EmiCalculatorScreen extends ConsumerWidget {
  const EmiCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(emiProvider);
    final notifier = ref.read(emiProvider.notifier);

    return CalculatorTemplate(
      title: 'EMI Calculator',
      icon: Icons.account_balance,
      inputSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NumericInputField(
            label: 'Loan Amount',
            prefix: '\u20B9 ',
            initialValue: state.principal,
            onChanged: (value) {
              if (value != null) notifier.setPrincipal(value);
            },
          ),
          const SizedBox(height: 24),
          LabeledSlider(
            label: 'Interest Rate (per annum)',
            value: state.annualRate,
            min: 1,
            max: 30,
            divisions: 290,
            suffix: '%',
            onChanged: notifier.setAnnualRate,
          ),
          const SizedBox(height: 24),
          LabeledSlider(
            label: 'Loan Tenure',
            value: state.tenureMonths.toDouble(),
            min: 1,
            max: 360,
            divisions: 359,
            suffix: ' months',
            onChanged: (value) => notifier.setTenureMonths(value.round()),
          ),
        ],
      ),
      resultsSection: Column(
        children: [
          ResultCard(
            title: 'Monthly EMI',
            value: CalculatorTemplate.formatCurrency(state.result?.emi ?? 0),
            icon: Icons.payments,
            valueColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          ResultCard(
            title: 'Total Interest',
            value: CalculatorTemplate.formatCurrency(
              state.result?.totalInterest ?? 0,
            ),
            icon: Icons.trending_up,
            valueColor: Colors.orange,
          ),
          const SizedBox(height: 12),
          ResultCard(
            title: 'Total Payment',
            value: CalculatorTemplate.formatCurrency(
              state.result?.totalPayment ?? 0,
            ),
            icon: Icons.account_balance_wallet,
            valueColor: Colors.green,
          ),
        ],
      ),
      onReset: notifier.reset,
    );
  }
}
