import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgeResult {
  final int years;
  final int months;
  final int days;
  final int totalDays;
  final int totalWeeks;
  final int totalMonths;
  final int totalYears;

  const AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
    required this.totalWeeks,
    required this.totalMonths,
    required this.totalYears,
  });
}

class AgeState {
  final DateTime birthDate;
  final DateTime? calculatedDate;
  final AgeResult? result;

  AgeState({DateTime? birthDate, DateTime? calculatedDate, this.result})
    : birthDate = birthDate ?? DateTime(2000, 1, 1),
      calculatedDate = calculatedDate ?? DateTime.now();

  AgeState copyWith({
    DateTime? birthDate,
    DateTime? calculatedDate,
    AgeResult? result,
  }) {
    return AgeState(
      birthDate: birthDate ?? this.birthDate,
      calculatedDate: calculatedDate ?? this.calculatedDate,
      result: result ?? this.result,
    );
  }

  AgeState calculate() {
    final birth = birthDate;
    final now = calculatedDate ?? DateTime.now();

    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDays = now.difference(birth).inDays;
    final totalWeeks = totalDays ~/ 7;
    final totalMonths = years * 12 + months;

    return copyWith(
      result: AgeResult(
        years: years,
        months: months,
        days: days,
        totalDays: totalDays,
        totalWeeks: totalWeeks,
        totalMonths: totalMonths,
        totalYears: years,
      ),
    );
  }
}

class AgeNotifier extends StateNotifier<AgeState> {
  AgeNotifier() : super(AgeState()) {
    state = state.calculate();
  }

  void setBirthDate(DateTime date) {
    state = state.copyWith(birthDate: date).calculate();
  }

  void setCalculatedDate(DateTime date) {
    state = state.copyWith(calculatedDate: date).calculate();
  }

  void reset() {
    state = AgeState().calculate();
  }
}

final ageProvider = StateNotifierProvider<AgeNotifier, AgeState>((ref) {
  return AgeNotifier();
});
