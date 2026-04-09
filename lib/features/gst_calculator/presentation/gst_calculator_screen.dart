import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/widgets.dart';
import 'gst_provider.dart';

class GstCalculatorScreen extends ConsumerWidget {
  const GstCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gstProvider);
    final notifier = ref.read(gstProvider.notifier);

    return CalculatorTemplate(
      title: 'GST Calculator',
      icon: Icons.receipt_long,
      inputSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NumericInputField(
            label: 'Base Amount',
            prefix: '\u20B9 ',
            initialValue: state.baseAmount,
            onChanged: (value) {
              if (value != null) notifier.setBaseAmount(value);
            },
          ),
          const SizedBox(height: 24),
          LabeledSlider(
            label: 'GST Rate',
            value: state.gstRate,
            min: 0,
            max: 28,
            divisions: 28,
            suffix: '%',
            onChanged: notifier.setGstRate,
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Interstate (IGST)')),
              ButtonSegment(
                value: false,
                label: Text('Intrastate (CGST+SGST)'),
              ),
            ],
            selected: {state.isInterstate},
            onSelectionChanged: (value) => notifier.setInterstate(value.first),
          ),
        ],
      ),
      resultsSection: Column(
        children: [
          if (!state.isInterstate) ...[
            ResultCard(
              title: 'CGST',
              value: CalculatorTemplate.formatCurrency(state.result?.cgst ?? 0),
              icon: Icons.remove_circle_outline,
              valueColor: Colors.blue,
            ),
            const SizedBox(height: 12),
            ResultCard(
              title: 'SGST',
              value: CalculatorTemplate.formatCurrency(state.result?.sgst ?? 0),
              icon: Icons.remove_circle_outline,
              valueColor: Colors.purple,
            ),
            const SizedBox(height: 12),
          ] else ...[
            ResultCard(
              title: 'IGST',
              value: CalculatorTemplate.formatCurrency(
                state.result?.totalGst ?? 0,
              ),
              icon: Icons.remove_circle_outline,
              valueColor: Colors.indigo,
            ),
            const SizedBox(height: 12),
          ],
          ResultCard(
            title: 'Total GST',
            value: CalculatorTemplate.formatCurrency(
              state.result?.totalGst ?? 0,
            ),
            icon: Icons.receipt,
            valueColor: Colors.orange,
          ),
          const SizedBox(height: 12),
          ResultCard(
            title: 'Total Amount',
            value: CalculatorTemplate.formatCurrency(
              state.result?.totalAmount ?? 0,
            ),
            icon: Icons.shopping_cart,
            valueColor: Colors.green,
          ),
        ],
      ),
      onReset: notifier.reset,
    );
  }
}
