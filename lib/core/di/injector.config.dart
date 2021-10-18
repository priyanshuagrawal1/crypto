import 'package:crypto_book/features/crypto_rates/data/data_sources/crypto_remote_data.dart';
import 'package:crypto_book/features/crypto_rates/data/repositiories/crypto_repository_impl.dart';
import 'package:crypto_book/features/crypto_rates/domain/repositiories/crypto_repositiory.dart';
import 'package:crypto_book/features/crypto_rates/domain/use_cases/get_all_cryptos.dart';
import 'package:crypto_book/features/crypto_rates/domain/use_cases/get_exchange_rates.dart';
import 'package:crypto_book/features/crypto_rates/domain/use_cases/get_history_of_crypto.dart';
import 'package:crypto_book/features/crypto_rates/presentation/bloc/bloc/crypto_bloc.dart';
import 'package:kiwi/kiwi.dart';

part 'injector.config.g.dart';

abstract class InjectorConfig {
  static KiwiContainer? container;
  static void setup() {
    container = KiwiContainer();
    final injector = _$InjectorConfig();
    injector._configure();
  }

  void _configure() {
    _configureDataSource();
    _configureBloc();
    _configureRepo();
    _configureUseCases();
  }

  @Register.factory(CryptoRemoteData, from: CryptoRemoteDataImpl)
  @Register.factory(CryptoRemoteDataImpl)
  void _configureDataSource();

  @Register.factory(CryptoBloc)
  void _configureBloc();

  @Register.factory(CryptoRepositiory, from: CryptoRepositoryImpl)
  @Register.factory(CryptoRepositoryImpl)
  void _configureRepo();

  @Register.singleton(GetExchangeRatesUseCase)
  @Register.singleton(GetHistoryOfCrypto)
  @Register.singleton(GetAllCryptos)
  void _configureUseCases();
}
