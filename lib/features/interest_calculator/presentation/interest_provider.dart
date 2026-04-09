import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/interest_calculator.dart';

enum InterestType { simple, compound }

class InterestState {
  final InterestType type;
  final double principal;
  final double rate;
  final int years;
  final int compoundingFrequency;
  final InterestResult? result;

  const InterestState({
    this.type = InterestType.simple,
    this.principal = 100000,
    this.rate = 8,
    this.years = 5,
    this.compoundingFrequency = 12,
    this.result,
  });

  InterestState copyWith({
    InterestType? type,
    double? principal,
    double? rate,
    int? years,
    int? compoundingFrequency,
    InterestResult? result,
  }) {
    return InterestState(
      type: type ?? this.type,
      principal: principal ?? this.principal,
      rate: rate ?? this.rate,
      years: years ?? this.years,
      compoundingFrequency: compoundingFrequency ?? this.compoundingFrequency,
      result: result ?? this.result,
    );
  }

  InterestState calculate() {
    InterestResult result;
    if (type == InterestType.simple) {
      result = InterestResult.calculateSimple(
        principal: principal,
        rate: rate,
        years: years,
      );
    } else {
      result = InterestResult.calculateCompound(
        principal: principal,
        rate: rate,
        years: years,
        compoundingFrequency: compoundingFrequency,
      );
    }
    return copyWith(result: result);
  }
}

class InterestNotifier extends StateNotifier<InterestState> {
  InterestNotifier() : super(const InterestState()) {
    state = state.calculate();
  }

  void setType(InterestType type) {
    state = state.copyWith(type: type).calculate();
  }

  void setPrincipal(double value) {
    state = state.copyWith(principal: value).calculate();
  }

  void setRate(double value) {
    state = state.copyWith(rate: value).calculate();
  }

  void setYears(int value) {
    state = state.copyWith(years: value).calculate();
  }

  void setCompoundingFrequency(int value) {
    state = state.copyWith(compoundingFrequency: value).calculate();
  }

  void reset() {
    state = const InterestState().calculate();
  }
}

final interestProvider = StateNotifierProvider<InterestNotifier, InterestState>(
  (ref) {
    return InterestNotifier();
  },
);
