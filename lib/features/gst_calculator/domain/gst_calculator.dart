class GstResult {
  final double cgst;
  final double sgst;
  final double totalGst;
  final double totalAmount;

  const GstResult({
    required this.cgst,
    required this.sgst,
    required this.totalGst,
    required this.totalAmount,
  });

  static GstResult calculate({
    required double baseAmount,
    required double gstRate,
    bool isInterstate = true,
  }) {
    if (baseAmount <= 0 || gstRate <= 0) {
      return const GstResult(cgst: 0, sgst: 0, totalGst: 0, totalAmount: 0);
    }

    final totalGst = baseAmount * gstRate / 100;
    final cgst = isInterstate ? totalGst / 2 : totalGst;
    final sgst = isInterstate ? totalGst / 2 : 0.0;
    final totalAmount = baseAmount + totalGst;

    return GstResult(
      cgst: cgst,
      sgst: sgst,
      totalGst: totalGst,
      totalAmount: totalAmount,
    );
  }
}
