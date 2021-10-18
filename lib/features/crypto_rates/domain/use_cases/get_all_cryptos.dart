import 'dart:developer';

import 'package:crypto_book/core/usecase/usecase.dart';
import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';
import 'package:crypto_book/features/crypto_rates/domain/repositiories/crypto_repositiory.dart';

class GetAllCryptos extends UseCase<dynamic, NoParam> {
  final CryptoRepositiory _cryptoRepository;
  GetAllCryptos(this._cryptoRepository);
  @override
  Future<List<Crypto>> call(param) async {
    try {
      return _cryptoRepository.getAllCrypto();
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
