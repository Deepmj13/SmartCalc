import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/widgets.dart';
import 'date_diff_provider.dart';

class DateDiffCalculatorScreen extends ConsumerWidget {
  const DateDiffCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dateDiffProvider);
    final notifier = ref.read(dateDiffProvider.notifier);

    return CalculatorTemplate(
      title: 'Date Difference',
      icon: Icons.date_range,
      inputSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DatePickerField(
            label: 'From Date',
            date: state.fromDate,
            onDateSelected: notifier.setFromDate,
          ),
          const SizedBox(height: 16),
          _DatePickerField(
            label: 'To Date',
            date: state.toDate,
            onDateSelected: notifier.setToDate,
          ),
        ],
      ),
      resultsSection: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Difference',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _DiffUnit(
                        value: state.result?.years ?? 0,
                        label: 'Years',
                      ),
                      _DiffUnit(
                        value: state.result?.months ?? 0,
                        label: 'Months',
                      ),
                      _DiffUnit(value: state.result?.days ?? 0, label: 'Days'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ResultCard(
                  title: 'Total Days',
                  value: CalculatorTemplate.formatNumber(
                    (state.result?.totalDays ?? 0).toDouble(),
                    decimalDigits: 0,
                  ),
                  icon: Icons.calendar_today,
                  valueColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ResultCard(
                  title: 'Total Weeks',
                  value: CalculatorTemplate.formatNumber(
                    (state.result?.totalWeeks ?? 0).toDouble(),
                    decimalDigits: 0,
                  ),
                  icon: Icons.date_range,
                  valueColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ResultCard(
                  title: 'Total Months',
                  value: CalculatorTemplate.formatNumber(
                    (state.result?.totalMonths ?? 0).toDouble(),
                    decimalDigits: 0,
                  ),
                  icon: Icons.calendar_month,
                  valueColor: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
      onReset: notifier.reset,
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selected = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (selected != null) {
              onDateSelected(selected);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 12),
                Text(
                  DateFormat('dd MMMM yyyy').format(date),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DiffUnit extends StatelessWidget {
  final int value;
  final String label;

  const _DiffUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
