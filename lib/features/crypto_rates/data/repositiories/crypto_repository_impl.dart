import 'package:crypto_book/features/crypto_rates/data/data_sources/crypto_remote_data.dart';
import 'package:crypto_book/features/crypto_rates/data/models/crypto_model.dart';
import 'package:crypto_book/features/crypto_rates/data/models/crypto_price_history_model.dart';
import 'package:crypto_book/features/crypto_rates/domain/repositiories/crypto_repositiory.dart';

class CryptoRepositoryImpl extends CryptoRepositiory {
  final CryptoRemoteData _cryptoRemoteData;

  CryptoRepositoryImpl(this._cryptoRemoteData);
  @override
  Future<List<CryptoModel>> getAllCrypto() async {
    return _cryptoRemoteData.getAllCrypto();
  }

  @override
  Future<CryptoPriceHistoryModel> getHistoryOfCrypto(
      String name, String interval) async {
    return _cryptoRemoteData.getHistoryOfCrypto(name, interval);
  }

  @override
  Future<Map<String, dynamic>> getExchangeRates() {
    return _cryptoRemoteData.getExchangeRates();
  }

  @override
  Future<CryptoModel> getCryptoInfo(String id) {
    return _cryptoRemoteData.getCryptoInfo(id);
  }
}
