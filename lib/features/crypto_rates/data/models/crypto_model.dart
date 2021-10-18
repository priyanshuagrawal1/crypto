import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';

class CryptoModel extends Crypto {
  CryptoModel({
    required String id,
    required String name,
    required String symbol,
    required double price,
    required int rank,
  }) : super(
          id: id,
          name: name,
          price: price,
          rank: rank,
          symbol: symbol,
        );
  factory CryptoModel.fromJson(Map data) => CryptoModel(
      id: data['id'],
      name: data['name'],
      symbol: data['symbol'],
      price: double.parse(data['priceUsd']),
      rank: int.parse(data['rank']));
}
