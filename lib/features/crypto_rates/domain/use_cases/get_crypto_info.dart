import 'package:crypto_book/core/usecase/usecase.dart';
import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';
import 'package:crypto_book/features/crypto_rates/domain/repositiories/crypto_repositiory.dart';

class GetCryptoInfo extends UseCase<dynamic, CryptoInfoParams> {
  final CryptoRepositiory _cryptoRepository;
  GetCryptoInfo(this._cryptoRepository);
  @override
  Future<Crypto> call(CryptoInfoParams param) {
    return _cryptoRepository.getCryptoInfo(param.id);
  }
}

class CryptoInfoParams {
  final String id;

  CryptoInfoParams(this.id);
}
