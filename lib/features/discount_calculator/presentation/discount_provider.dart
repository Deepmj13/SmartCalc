import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/discount_calculator.dart';

enum DiscountMode { discount, profitLoss, tip }

class DiscountState {
  final DiscountMode mode;
  final double amount1;
  final double amount2;
  final int numberOfPeople;
  final DiscountResult? discountResult;
  final TipResult? tipResult;

  const DiscountState({
    this.mode = DiscountMode.discount,
    this.amount1 = 1000,
    this.amount2 = 10,
    this.numberOfPeople = 1,
    this.discountResult,
    this.tipResult,
  });

  DiscountState copyWith({
    DiscountMode? mode,
    double? amount1,
    double? amount2,
    int? numberOfPeople,
    DiscountResult? discountResult,
    TipResult? tipResult,
  }) {
    return DiscountState(
      mode: mode ?? this.mode,
      amount1: amount1 ?? this.amount1,
      amount2: amount2 ?? this.amount2,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      discountResult: discountResult ?? this.discountResult,
      tipResult: tipResult ?? this.tipResult,
    );
  }

  DiscountState calculate() {
    switch (mode) {
      case DiscountMode.discount:
        return copyWith(
          discountResult: DiscountResult.calculateDiscount(
            originalPrice: amount1,
            discountPercent: amount2,
          ),
        );
      case DiscountMode.profitLoss:
        return copyWith(
          discountResult: DiscountResult.calculateProfitLoss(
            costPrice: amount1,
            sellingPrice: amount2,
          ),
        );
      case DiscountMode.tip:
        return copyWith(
          tipResult: TipResult.calculate(
            billAmount: amount1,
            tipPercent: amount2,
            numberOfPeople: numberOfPeople,
          ),
        );
    }
  }
}

class DiscountNotifier extends StateNotifier<DiscountState> {
  DiscountNotifier() : super(const DiscountState()) {
    state = state.calculate();
  }

  void setMode(DiscountMode mode) {
    state = state.copyWith(mode: mode).calculate();
  }

  void setAmount1(double value) {
    state = state.copyWith(amount1: value).calculate();
  }

  void setAmount2(double value) {
    state = state.copyWith(amount2: value).calculate();
  }

  void setNumberOfPeople(int value) {
    state = state.copyWith(numberOfPeople: value).calculate();
  }

  void reset() {
    state = const DiscountState().calculate();
  }
}

final discountProvider = StateNotifierProvider<DiscountNotifier, DiscountState>(
  (ref) {
    return DiscountNotifier();
  },
);
