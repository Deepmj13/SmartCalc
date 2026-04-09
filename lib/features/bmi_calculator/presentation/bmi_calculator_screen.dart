import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/widgets.dart';
import 'bmi_provider.dart';

class BmiCalculatorScreen extends ConsumerWidget {
  const BmiCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bmiProvider);
    final notifier = ref.read(bmiProvider.notifier);

    return CalculatorTemplate(
      title: 'BMI Calculator',
      icon: Icons.monitor_weight,
      inputSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledSlider(
            label: 'Height',
            value: state.height,
            min: 100,
            max: 250,
            divisions: 150,
            suffix: ' cm',
            onChanged: notifier.setHeight,
          ),
          const SizedBox(height: 24),
          LabeledSlider(
            label: 'Weight',
            value: state.weight,
            min: 20,
            max: 200,
            divisions: 180,
            suffix: ' kg',
            onChanged: notifier.setWeight,
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
                    'Your BMI',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.result?.bmi.toStringAsFixed(1) ?? '0',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Color(state.result?.colorInfo.color ?? 0xFF6B7280),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(state.result?.colorInfo.color ?? 0xFF6B7280),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      state.result?.category ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _BmiRangeIndicator(
                  label: 'Underweight',
                  range: '< 18.5',
                  color: const Color(0xFF3B82F6),
                  isActive: (state.result?.bmi ?? 0) < 18.5,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BmiRangeIndicator(
                  label: 'Normal',
                  range: '18.5 - 24.9',
                  color: const Color(0xFF22C55E),
                  isActive:
                      (state.result?.bmi ?? 0) >= 18.5 &&
                      (state.result?.bmi ?? 0) < 25,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _BmiRangeIndicator(
                  label: 'Overweight',
                  range: '25 - 29.9',
                  color: const Color(0xFFF59E0B),
                  isActive:
                      (state.result?.bmi ?? 0) >= 25 &&
                      (state.result?.bmi ?? 0) < 30,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BmiRangeIndicator(
                  label: 'Obese',
                  range: '>= 30',
                  color: const Color(0xFFEF4444),
                  isActive: (state.result?.bmi ?? 0) >= 30,
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

class _BmiRangeIndicator extends StatelessWidget {
  final String label;
  final String range;
  final Color color;
  final bool isActive;

  const _BmiRangeIndicator({
    required this.label,
    required this.range,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color : Colors.grey.withValues(alpha: 0.3),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? color : null,
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
