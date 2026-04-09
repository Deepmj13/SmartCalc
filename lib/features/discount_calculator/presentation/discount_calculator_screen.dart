import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/widgets.dart';
import 'discount_provider.dart';

class DiscountCalculatorScreen extends ConsumerWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discountProvider);
    final notifier = ref.read(discountProvider.notifier);

    return CalculatorTemplate(
      title: 'Discount & More',
      icon: Icons.local_offer,
      inputSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<DiscountMode>(
            segments: const [
              ButtonSegment(
                value: DiscountMode.discount,
                label: Text('Discount'),
              ),
              ButtonSegment(value: DiscountMode.profitLoss, label: Text('P/L')),
              ButtonSegment(value: DiscountMode.tip, label: Text('Tip')),
            ],
            selected: {state.mode},
            onSelectionChanged: (value) => notifier.setMode(value.first),
          ),
          const SizedBox(height: 24),
          switch (state.mode) {
            DiscountMode.discount => _DiscountInputs(
              state: state,
              notifier: notifier,
            ),
            DiscountMode.profitLoss => _ProfitLossInputs(
              state: state,
              notifier: notifier,
            ),
            DiscountMode.tip => _TipInputs(state: state, notifier: notifier),
          },
        ],
      ),
      resultsSection: _buildResults(context, state),
      onReset: notifier.reset,
    );
  }

  Widget _buildResults(BuildContext context, DiscountState state) {
    switch (state.mode) {
      case DiscountMode.discount:
        return Column(
          children: [
            ResultCard(
              title: 'You Save',
              value: CalculatorTemplate.formatCurrency(
                state.discountResult?.discountAmount ?? 0,
              ),
              icon: Icons.savings,
              valueColor: Colors.green,
            ),
            const SizedBox(height: 12),
            ResultCard(
              title: 'Final Price',
              value: CalculatorTemplate.formatCurrency(
                state.discountResult?.finalPrice ?? 0,
              ),
              icon: Icons.shopping_cart,
              valueColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        );
      case DiscountMode.profitLoss:
        final isProfit = (state.discountResult?.profitLoss ?? 0) >= 0;
        return Column(
          children: [
            ResultCard(
              title: isProfit ? 'Profit' : 'Loss',
              value: CalculatorTemplate.formatCurrency(
                state.discountResult?.profitLoss?.abs() ?? 0,
              ),
              icon: isProfit ? Icons.trending_up : Icons.trending_down,
              valueColor: isProfit ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 12),
            ResultCard(
              title: 'Profit/Loss %',
              value:
                  '${(state.discountResult?.profitLossPercent ?? 0).toStringAsFixed(2)}%',
              icon: Icons.percent,
              valueColor: isProfit ? Colors.green : Colors.red,
            ),
          ],
        );
      case DiscountMode.tip:
        return Column(
          children: [
            ResultCard(
              title: 'Tip Amount',
              value: CalculatorTemplate.formatCurrency(
                state.tipResult?.tipAmount ?? 0,
              ),
              icon: Icons.volunteer_activism,
              valueColor: Colors.orange,
            ),
            const SizedBox(height: 12),
            ResultCard(
              title: 'Total Per Person',
              value: CalculatorTemplate.formatCurrency(
                state.tipResult?.perPerson ?? 0,
              ),
              icon: Icons.person,
              valueColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            ResultCard(
              title: 'Total Bill',
              value: CalculatorTemplate.formatCurrency(
                state.tipResult?.totalAmount ?? 0,
              ),
              icon: Icons.receipt,
              valueColor: Colors.blue,
            ),
          ],
        );
    }
  }
}

class _DiscountInputs extends StatelessWidget {
  final DiscountState state;
  final DiscountNotifier notifier;

  const _DiscountInputs({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumericInputField(
          label: 'Original Price',
          prefix: '\u20B9 ',
          initialValue: state.amount1,
          onChanged: (v) => v != null ? notifier.setAmount1(v) : null,
        ),
        const SizedBox(height: 16),
        LabeledSlider(
          label: 'Discount',
          value: state.amount2,
          min: 0,
          max: 100,
          divisions: 100,
          suffix: '%',
          onChanged: notifier.setAmount2,
        ),
      ],
    );
  }
}

class _ProfitLossInputs extends StatelessWidget {
  final DiscountState state;
  final DiscountNotifier notifier;

  const _ProfitLossInputs({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumericInputField(
          label: 'Cost Price',
          prefix: '\u20B9 ',
          initialValue: state.amount1,
          onChanged: (v) => v != null ? notifier.setAmount1(v) : null,
        ),
        const SizedBox(height: 16),
        NumericInputField(
          label: 'Selling Price',
          prefix: '\u20B9 ',
          initialValue: state.amount2,
          onChanged: (v) => v != null ? notifier.setAmount2(v) : null,
        ),
      ],
    );
  }
}

class _TipInputs extends StatelessWidget {
  final DiscountState state;
  final DiscountNotifier notifier;

  const _TipInputs({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumericInputField(
          label: 'Bill Amount',
          prefix: '\u20B9 ',
          initialValue: state.amount1,
          onChanged: (v) => v != null ? notifier.setAmount1(v) : null,
        ),
        const SizedBox(height: 16),
        LabeledSlider(
          label: 'Tip',
          value: state.amount2,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: '%',
          onChanged: notifier.setAmount2,
        ),
        const SizedBox(height: 16),
        LabeledSlider(
          label: 'Split Between',
          value: state.numberOfPeople.toDouble(),
          min: 1,
          max: 20,
          divisions: 19,
          suffix: state.numberOfPeople == 1 ? ' person' : ' people',
          onChanged: (v) => notifier.setNumberOfPeople(v.round()),
        ),
      ],
    );
  }
}
