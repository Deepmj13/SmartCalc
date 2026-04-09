class EmiResult {
  final double emi;
  final double totalInterest;
  final double totalPayment;
  final double monthlyInterestRate;

  const EmiResult({
    required this.emi,
    required this.totalInterest,
    required this.totalPayment,
    required this.monthlyInterestRate,
  });

  static EmiResult calculate({
    required double principal,
    required double annualRate,
    required int tenureMonths,
  }) {
    if (principal <= 0 || tenureMonths <= 0) {
      return const EmiResult(
        emi: 0,
        totalInterest: 0,
        totalPayment: 0,
        monthlyInterestRate: 0,
      );
    }

    final monthlyRate = annualRate / 12 / 100;

    double emi;
    if (monthlyRate == 0) {
      emi = principal / tenureMonths;
    } else {
      emi =
          principal *
          monthlyRate *
          _power(1 + monthlyRate, tenureMonths) /
          (_power(1 + monthlyRate, tenureMonths) - 1);
    }

    final totalPayment = emi * tenureMonths;
    final totalInterest = totalPayment - principal;

    return EmiResult(
      emi: emi,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
      monthlyInterestRate: monthlyRate * 100,
    );
  }

  static double _power(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
