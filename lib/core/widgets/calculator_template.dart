import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculatorTemplate extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget inputSection;
  final Widget resultsSection;
  final VoidCallback? onReset;

  const CalculatorTemplate({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    required this.inputSection,
    required this.resultsSection,
    this.onReset,
  });

  static final _currencyFormat = NumberFormat.currency(
    symbol: '\u20B9',
    decimalDigits: 2,
  );
  static final _percentFormat = NumberFormat.decimalPercentPattern(
    decimalDigits: 2,
  );

  static String formatCurrency(double value) => _currencyFormat.format(value);
  static String formatPercent(double value) =>
      _percentFormat.format(value / 100);
  static String formatNumber(double value, {int decimalDigits = 2}) =>
      NumberFormat.decimalPattern().format(
        double.parse(value.toStringAsFixed(decimalDigits)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        actions: [
          if (onReset != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onReset,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: inputSection,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Results',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            resultsSection,
          ],
        ),
      ),
    );
  }
}
