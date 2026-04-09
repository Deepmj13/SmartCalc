class InterestResult {
  final double interest;
  final double totalAmount;
  final double? effectiveRate;
  final List<YearlyBreakdown>? breakdown;

  const InterestResult({
    required this.interest,
    required this.totalAmount,
    this.effectiveRate,
    this.breakdown,
  });

  static InterestResult calculateSimple({
    required double principal,
    required double rate,
    required int years,
  }) {
    if (principal <= 0 || rate <= 0 || years <= 0) {
      return const InterestResult(interest: 0, totalAmount: 0);
    }

    final interest = principal * rate * years / 100;
    final totalAmount = principal + interest;

    return InterestResult(interest: interest, totalAmount: totalAmount);
  }

  static InterestResult calculateCompound({
    required double principal,
    required double rate,
    required int years,
    required int compoundingFrequency,
  }) {
    if (principal <= 0 || rate <= 0 || years <= 0) {
      return const InterestResult(interest: 0, totalAmount: 0);
    }

    final n = compoundingFrequency.toDouble();
    final r = rate / 100;
    final totalAmount = principal * _power(1 + r / n, n * years);
    final interest = totalAmount - principal;
    final effectiveRate = (_power(1 + r / n, n) - 1) * 100;

    final breakdown = <YearlyBreakdown>[];
    for (int y = 1; y <= years; y++) {
      final amount = principal * _power(1 + r / n, n * y);
      breakdown.add(
        YearlyBreakdown(year: y, amount: amount, interest: amount - principal),
      );
    }

    return InterestResult(
      interest: interest,
      totalAmount: totalAmount,
      effectiveRate: effectiveRate,
      breakdown: breakdown,
    );
  }

  static double _power(double base, double exponent) {
    double result = 1;
    for (int i = 0; i < exponent.toInt(); i++) {
      result *= base;
    }
    return result;
  }
}

class YearlyBreakdown {
  final int year;
  final double amount;
  final double interest;

  const YearlyBreakdown({
    required this.year,
    required this.amount,
    required this.interest,
  });
}
