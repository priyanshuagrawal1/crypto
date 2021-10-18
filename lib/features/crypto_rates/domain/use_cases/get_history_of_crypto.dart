import 'package:crypto_book/core/usecase/usecase.dart';
import 'package:crypto_book/features/crypto_rates/domain/entities/crypto_price_history.dart';
import 'package:crypto_book/features/crypto_rates/domain/repositiories/crypto_repositiory.dart';

class GetHistoryOfCrypto extends UseCase<dynamic, SearchParam> {
  final CryptoRepositiory _cryptoRepository;

  GetHistoryOfCrypto(this._cryptoRepository);
  @override
  Future<CryptoPriceHistory> call(param) async {
    return _cryptoRepository.getHistoryOfCrypto(param.name, param.interval);
  }
}

class SearchParam {
  final String name;
  final String interval;
  SearchParam(this.name, {this.interval = 'd1'});
}
