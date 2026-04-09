class DiscountResult {
  final double discountAmount;
  final double finalPrice;
  final double? profitLoss;
  final double? profitLossPercent;

  const DiscountResult({
    required this.discountAmount,
    required this.finalPrice,
    this.profitLoss,
    this.profitLossPercent,
  });

  static DiscountResult calculateDiscount({
    required double originalPrice,
    required double discountPercent,
  }) {
    if (originalPrice <= 0 || discountPercent < 0) {
      return const DiscountResult(discountAmount: 0, finalPrice: 0);
    }

    final discountAmount = originalPrice * discountPercent / 100;
    final finalPrice = originalPrice - discountAmount;

    return DiscountResult(
      discountAmount: discountAmount,
      finalPrice: finalPrice,
    );
  }

  static DiscountResult calculateProfitLoss({
    required double costPrice,
    required double sellingPrice,
  }) {
    final profitLoss = sellingPrice - costPrice;
    final profitLossPercent = costPrice > 0
        ? (profitLoss / costPrice) * 100
        : 0.0;

    return DiscountResult(
      discountAmount: 0,
      finalPrice: sellingPrice,
      profitLoss: profitLoss,
      profitLossPercent: profitLossPercent,
    );
  }
}

class TipResult {
  final double tipAmount;
  final double perPerson;
  final double totalAmount;

  const TipResult({
    required this.tipAmount,
    required this.perPerson,
    required this.totalAmount,
  });

  static TipResult calculate({
    required double billAmount,
    required double tipPercent,
    required int numberOfPeople,
  }) {
    if (billAmount <= 0 || numberOfPeople <= 0) {
      return const TipResult(tipAmount: 0, perPerson: 0, totalAmount: 0);
    }

    final tipAmount = billAmount * tipPercent / 100;
    final totalAmount = billAmount + tipAmount;
    final perPerson = totalAmount / numberOfPeople;

    return TipResult(
      tipAmount: tipAmount,
      perPerson: perPerson,
      totalAmount: totalAmount,
    );
  }
}
