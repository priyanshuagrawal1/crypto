import 'package:crypto_book/features/crypto_rates/domain/entities/crypto_price_history.dart';

class CryptoPriceHistoryModel extends CryptoPriceHistory {
  CryptoPriceHistoryModel({
    required List<Map<String, dynamic>> priceHistory,
    required String name,
  }) : super(
          name: name,
          priceHistory: priceHistory,
        );
}
