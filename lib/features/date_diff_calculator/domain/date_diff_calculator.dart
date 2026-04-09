class DateDiffResult {
  final int years;
  final int months;
  final int days;
  final int totalDays;
  final int totalWeeks;
  final int totalMonths;

  const DateDiffResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
    required this.totalWeeks,
    required this.totalMonths,
  });

  static DateDiffResult calculate(DateTime from, DateTime to) {
    if (to.isBefore(from)) {
      return calculate(to, from);
    }

    int years = to.year - from.year;
    int months = to.month - from.month;
    int days = to.day - from.day;

    if (days < 0) {
      months--;
      days += DateTime(to.year, to.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDays = to.difference(from).inDays;
    final totalWeeks = totalDays ~/ 7;
    final totalMonths = years * 12 + months;

    return DateDiffResult(
      years: years,
      months: months,
      days: days,
      totalDays: totalDays,
      totalWeeks: totalWeeks,
      totalMonths: totalMonths,
    );
  }
}
