import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/gst_calculator.dart';

class GstState {
  final double baseAmount;
  final double gstRate;
  final bool isInterstate;
  final GstResult? result;

  const GstState({
    this.baseAmount = 1000,
    this.gstRate = 18,
    this.isInterstate = true,
    this.result,
  });

  GstState copyWith({
    double? baseAmount,
    double? gstRate,
    bool? isInterstate,
    GstResult? result,
  }) {
    return GstState(
      baseAmount: baseAmount ?? this.baseAmount,
      gstRate: gstRate ?? this.gstRate,
      isInterstate: isInterstate ?? this.isInterstate,
      result: result ?? this.result,
    );
  }

  GstState calculate() {
    return copyWith(
      result: GstResult.calculate(
        baseAmount: baseAmount,
        gstRate: gstRate,
        isInterstate: isInterstate,
      ),
    );
  }
}

class GstNotifier extends StateNotifier<GstState> {
  GstNotifier() : super(const GstState()) {
    state = state.calculate();
  }

  void setBaseAmount(double value) {
    state = state.copyWith(baseAmount: value).calculate();
  }

  void setGstRate(double value) {
    state = state.copyWith(gstRate: value).calculate();
  }

  void setInterstate(bool value) {
    state = state.copyWith(isInterstate: value).calculate();
  }

  void reset() {
    state = const GstState().calculate();
  }
}

final gstProvider = StateNotifierProvider<GstNotifier, GstState>((ref) {
  return GstNotifier();
});
