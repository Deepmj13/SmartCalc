import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/unit_converter.dart';
import 'unit_converter_provider.dart';

class UnitConverterScreen extends ConsumerWidget {
  const UnitConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unitConverterProvider);
    final notifier = ref.read(unitConverterProvider.notifier);
    final units = UnitConversion.getUnitsForCategory(state.category);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(state.category),
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Unit Converter'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CategorySelector(
              selected: state.category,
              onChanged: notifier.setCategory,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _UnitDropdown(
                      label: 'From',
                      value: state.fromUnit,
                      units: units.keys.toList(),
                      onChanged: notifier.setFromUnit,
                    ),
                    const SizedBox(height: 16),
                    NumericInputField(
                      label: 'Value',
                      initialValue: state.inputValue,
                      onChanged: (v) =>
                          v != null ? notifier.setInputValue(v) : null,
                    ),
                    const SizedBox(height: 16),
                    IconButton.filled(
                      onPressed: notifier.swapUnits,
                      icon: const Icon(Icons.swap_vert),
                    ),
                    const SizedBox(height: 16),
                    _UnitDropdown(
                      label: 'To',
                      value: state.toUnit,
                      units: units.keys.toList(),
                      onChanged: notifier.setToUnit,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Result',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatResult(state.result),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      state.toUnit,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatResult(double value) {
    if (value == value.truncateToDouble()) {
      return value.truncate().toString();
    }
    return NumberFormat('#,##0.######').format(value);
  }

  IconData _getCategoryIcon(UnitCategory category) {
    switch (category) {
      case UnitCategory.length:
        return Icons.straighten;
      case UnitCategory.weight:
        return Icons.scale;
      case UnitCategory.temperature:
        return Icons.thermostat;
      case UnitCategory.data:
        return Icons.storage;
    }
  }
}

class _CategorySelector extends StatelessWidget {
  final UnitCategory selected;
  final ValueChanged<UnitCategory> onChanged;

  const _CategorySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<UnitCategory>(
      segments: const [
        ButtonSegment(
          value: UnitCategory.length,
          label: Text('Length'),
          icon: Icon(Icons.straighten),
        ),
        ButtonSegment(
          value: UnitCategory.weight,
          label: Text('Weight'),
          icon: Icon(Icons.scale),
        ),
        ButtonSegment(
          value: UnitCategory.temperature,
          label: Text('Temp'),
          icon: Icon(Icons.thermostat),
        ),
        ButtonSegment(
          value: UnitCategory.data,
          label: Text('Data'),
          icon: Icon(Icons.storage),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (value) => onChanged(value.first),
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> units;
  final ValueChanged<String> onChanged;

  const _UnitDropdown({
    required this.label,
    required this.value,
    required this.units,
    required this.onChanged,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: units
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
            onChanged: (v) => v != null ? onChanged(v) : null,
          ),
        ),
      ],
    );
  }
}
