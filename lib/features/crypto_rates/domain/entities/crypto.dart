class Crypto {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double change;
  final int rank;
  final double supply;
  final double marketCapUsd;
  final double volumeUsd24Hr;
  final double priceUsd;
  final double vwap24Hr;

  Crypto({
    required this.supply,
    required this.marketCapUsd,
    required this.volumeUsd24Hr,
    required this.priceUsd,
    required this.vwap24Hr,
    required this.change,
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.rank,
  });
}
