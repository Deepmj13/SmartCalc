import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/emi_calculator.dart';

class EmiState {
  final double principal;
  final double annualRate;
  final int tenureMonths;
  final EmiResult? result;

  const EmiState({
    this.principal = 100000,
    this.annualRate = 8.5,
    this.tenureMonths = 12,
    this.result,
  });

  EmiState copyWith({
    double? principal,
    double? annualRate,
    int? tenureMonths,
    EmiResult? result,
  }) {
    return EmiState(
      principal: principal ?? this.principal,
      annualRate: annualRate ?? this.annualRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      result: result ?? this.result,
    );
  }

  EmiState calculate() {
    return copyWith(
      result: EmiResult.calculate(
        principal: principal,
        annualRate: annualRate,
        tenureMonths: tenureMonths,
      ),
    );
  }
}

class EmiNotifier extends StateNotifier<EmiState> {
  EmiNotifier() : super(const EmiState()) {
    state = state.calculate();
  }

  void setPrincipal(double value) {
    state = state.copyWith(principal: value).calculate();
  }

  void setAnnualRate(double value) {
    state = state.copyWith(annualRate: value).calculate();
  }

  void setTenureMonths(int value) {
    state = state.copyWith(tenureMonths: value).calculate();
  }

  void reset() {
    state = const EmiState().calculate();
  }
}

final emiProvider = StateNotifierProvider<EmiNotifier, EmiState>((ref) {
  return EmiNotifier();
});
