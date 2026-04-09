import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/unit_converter.dart';

class UnitConverterState {
  final UnitCategory category;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double result;

  const UnitConverterState({
    this.category = UnitCategory.length,
    this.fromUnit = 'Meter',
    this.toUnit = 'Kilometer',
    this.inputValue = 1,
    this.result = 0.001,
  });

  UnitConverterState copyWith({
    UnitCategory? category,
    String? fromUnit,
    String? toUnit,
    double? inputValue,
    double? result,
  }) {
    return UnitConverterState(
      category: category ?? this.category,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      inputValue: inputValue ?? this.inputValue,
      result: result ?? this.result,
    );
  }

  UnitConverterState calculate() {
    final result = UnitConversion.convert(
      inputValue,
      fromUnit,
      toUnit,
      category,
    );
    return copyWith(result: result);
  }

  UnitConverterState switchUnits() {
    return copyWith(fromUnit: toUnit, toUnit: fromUnit).calculate();
  }
}

class UnitConverterNotifier extends StateNotifier<UnitConverterState> {
  UnitConverterNotifier() : super(const UnitConverterState()) {
    state = state.calculate();
  }

  void setCategory(UnitCategory category) {
    final units = UnitConversion.getUnitsForCategory(category);
    final unitList = units.keys.toList();
    state = UnitConverterState(
      category: category,
      fromUnit: unitList.first,
      toUnit: unitList.length > 1 ? unitList[1] : unitList.first,
    ).calculate();
  }

  void setFromUnit(String unit) {
    state = state.copyWith(fromUnit: unit).calculate();
  }

  void setToUnit(String unit) {
    state = state.copyWith(toUnit: unit).calculate();
  }

  void setInputValue(double value) {
    state = state.copyWith(inputValue: value).calculate();
  }

  void swapUnits() {
    state = state.switchUnits();
  }
}

final unitConverterProvider =
    StateNotifierProvider<UnitConverterNotifier, UnitConverterState>((ref) {
      return UnitConverterNotifier();
    });
