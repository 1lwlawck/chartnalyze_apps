class NormalizedPricePoint {
  final String symbol;
  final DateTime scrapedAt;
  final double normalizedPrice;

  NormalizedPricePoint({
    required this.symbol,
    required this.scrapedAt,
    required this.normalizedPrice,
  });
}
