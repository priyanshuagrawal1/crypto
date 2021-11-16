import 'package:crypto_book/features/crypto_rates/data/models/crypto_model.dart';
import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';
import 'package:crypto_book/features/crypto_rates/domain/entities/crypto_price_history.dart';

abstract class CryptoRepositiory {
  Future<List<Crypto>> getAllCrypto();
  Future<CryptoPriceHistory> getHistoryOfCrypto(String name, String interval);
  Future<Map<String, dynamic>> getExchangeRates();
  Future<CryptoModel> getCryptoInfo(String id);
}
