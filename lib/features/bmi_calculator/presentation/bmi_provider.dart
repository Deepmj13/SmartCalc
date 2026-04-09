import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/bmi_calculator.dart';

class BmiState {
  final double height;
  final double weight;
  final BmiResult? result;

  const BmiState({this.height = 170, this.weight = 70, this.result});

  BmiState copyWith({double? height, double? weight, BmiResult? result}) {
    return BmiState(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      result: result ?? this.result,
    );
  }

  BmiState calculate() {
    return copyWith(result: BmiResult.calculate(height, weight));
  }
}

class BmiNotifier extends StateNotifier<BmiState> {
  BmiNotifier() : super(const BmiState()) {
    state = state.calculate();
  }

  void setHeight(double value) {
    state = state.copyWith(height: value).calculate();
  }

  void setWeight(double value) {
    state = state.copyWith(weight: value).calculate();
  }

  void reset() {
    state = const BmiState().calculate();
  }
}

final bmiProvider = StateNotifierProvider<BmiNotifier, BmiState>((ref) {
  return BmiNotifier();
});
