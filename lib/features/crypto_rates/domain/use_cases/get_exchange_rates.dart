import 'package:crypto_book/core/usecase/usecase.dart';
import 'package:crypto_book/features/crypto_rates/domain/repositiories/crypto_repositiory.dart';

class GetExchangeRatesUseCase extends UseCase<dynamic, NoParam> {
  final CryptoRepositiory cryptoRepositiory;

  GetExchangeRatesUseCase(this.cryptoRepositiory);
  @override
  Future<Map<String, dynamic>> call(NoParam param) async {
    return cryptoRepositiory.getExchangeRates();
  }
}
