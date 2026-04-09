import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/date_diff_calculator.dart';

class DateDiffState {
  final DateTime fromDate;
  final DateTime toDate;
  final DateDiffResult? result;

  DateDiffState({DateTime? fromDate, DateTime? toDate, this.result})
    : fromDate = fromDate ?? DateTime.now().subtract(const Duration(days: 365)),
      toDate = toDate ?? DateTime.now();

  DateDiffState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    DateDiffResult? result,
  }) {
    return DateDiffState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      result: result ?? this.result,
    );
  }

  DateDiffState calculate() {
    return copyWith(result: DateDiffResult.calculate(fromDate, toDate));
  }
}

class DateDiffNotifier extends StateNotifier<DateDiffState> {
  DateDiffNotifier() : super(DateDiffState()) {
    state = state.calculate();
  }

  void setFromDate(DateTime date) {
    state = state.copyWith(fromDate: date).calculate();
  }

  void setToDate(DateTime date) {
    state = state.copyWith(toDate: date).calculate();
  }

  void reset() {
    state = DateDiffState().calculate();
  }
}

final dateDiffProvider = StateNotifierProvider<DateDiffNotifier, DateDiffState>(
  (ref) {
    return DateDiffNotifier();
  },
);
