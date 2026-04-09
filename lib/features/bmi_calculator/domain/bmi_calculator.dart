class BmiResult {
  final double bmi;
  final String category;
  final double healthyMin;
  final double healthyMax;

  const BmiResult({
    required this.bmi,
    required this.category,
    required this.healthyMin,
    required this.healthyMax,
  });

  static BmiResult calculate(double heightCm, double weightKg) {
    if (heightCm <= 0 || weightKg <= 0) {
      return const BmiResult(
        bmi: 0,
        category: 'Invalid',
        healthyMin: 18.5,
        healthyMax: 24.9,
      );
    }

    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);
    final category = _getCategory(bmi);

    return BmiResult(
      bmi: bmi,
      category: category,
      healthyMin: 18.5,
      healthyMax: 24.9,
    );
  }

  static String _getCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  ColorInfo get colorInfo {
    switch (category) {
      case 'Underweight':
        return const ColorInfo(color: 0xFF3B82F6, label: 'Blue');
      case 'Normal':
        return const ColorInfo(color: 0xFF22C55E, label: 'Green');
      case 'Overweight':
        return const ColorInfo(color: 0xFFF59E0B, label: 'Orange');
      case 'Obese':
        return const ColorInfo(color: 0xFFEF4444, label: 'Red');
      default:
        return const ColorInfo(color: 0xFF6B7280, label: 'Gray');
    }
  }
}

class ColorInfo {
  final int color;
  final String label;

  const ColorInfo({required this.color, required this.label});
}
