import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';

class CryptoModel extends Crypto {
  CryptoModel({
    required String id,
    required String name,
    required String symbol,
    required double price,
    required int rank,
    required double change,
    required final double supply,
    required final double marketCapUsd,
    required final double volumeUsd24Hr,
    required final double priceUsd,
    required final double vwap24Hr,
  }) : super(
          marketCapUsd: marketCapUsd,
          priceUsd: priceUsd,
          supply: supply,
          volumeUsd24Hr: volumeUsd24Hr,
          vwap24Hr: vwap24Hr,
          change: change,
          id: id,
          name: name,
          price: price,
          rank: rank,
          symbol: symbol,
        );
  factory CryptoModel.fromJson(Map data) => CryptoModel(
        change: double.parse(data['changePercent24Hr'] ?? '0'),
        id: data['id'] ?? '0',
        name: data['name'] ?? '0',
        symbol: data['symbol'] ?? '0',
        price: double.parse(data['priceUsd'] ?? '0'),
        rank: int.parse(data['rank'] ?? '0'),
        marketCapUsd: double.parse(data['marketCapUsd'] ?? '0'),
        priceUsd: double.parse(data['priceUsd'] ?? '0'),
        supply: double.parse(data['supply'] ?? '0'),
        volumeUsd24Hr: double.parse(data['volumeUsd24Hr'] ?? '0'),
        vwap24Hr: double.parse(data['vwap24Hr'] ?? '0'),
      );
}
