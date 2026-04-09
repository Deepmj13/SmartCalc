enum UnitCategory { length, weight, temperature, data }

class UnitConversion {
  static const _lengthFactors = {
    'Meter': 1.0,
    'Kilometer': 1000.0,
    'Centimeter': 0.01,
    'Millimeter': 0.001,
    'Mile': 1609.344,
    'Yard': 0.9144,
    'Foot': 0.3048,
    'Inch': 0.0254,
  };

  static const _weightFactors = {
    'Kilogram': 1.0,
    'Gram': 0.001,
    'Milligram': 0.000001,
    'Pound': 0.453592,
    'Ounce': 0.0283495,
    'Ton': 1000.0,
  };

  static const _dataFactors = {
    'Byte': 1.0,
    'Kilobyte': 1024.0,
    'Megabyte': 1048576.0,
    'Gigabyte': 1073741824.0,
    'Terabyte': 1099511627776.0,
    'Bit': 0.125,
    'Kilobit': 128.0,
    'Megabit': 131072.0,
    'Gigabit': 134217728.0,
  };

  static Map<String, double> getUnitsForCategory(UnitCategory category) {
    switch (category) {
      case UnitCategory.length:
        return _lengthFactors;
      case UnitCategory.weight:
        return _weightFactors;
      case UnitCategory.temperature:
        return {'Celsius': 1, 'Fahrenheit': 1, 'Kelvin': 1};
      case UnitCategory.data:
        return _dataFactors;
    }
  }

  static double convert(
    double value,
    String fromUnit,
    String toUnit,
    UnitCategory category,
  ) {
    if (fromUnit == toUnit) return value;

    if (category == UnitCategory.temperature) {
      return _convertTemperature(value, fromUnit, toUnit);
    }

    final factors = getUnitsForCategory(category);
    final fromFactor = factors[fromUnit] ?? 1.0;
    final toFactor = factors[toUnit] ?? 1.0;

    final baseValue = value * fromFactor;
    return baseValue / toFactor;
  }

  static double _convertTemperature(double value, String from, String to) {
    double celsius;
    switch (from) {
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    switch (to) {
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }
}
