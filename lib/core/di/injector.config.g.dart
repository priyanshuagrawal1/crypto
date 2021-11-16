// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.config.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$InjectorConfig extends InjectorConfig {
  @override
  void _configureDataSource() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory<CryptoRemoteData>((c) => CryptoRemoteDataImpl())
      ..registerFactory((c) => CryptoRemoteDataImpl());
  }

  @override
  void _configureBloc() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => CryptoBloc(
          c<GetAllCryptos>(),
          c<GetHistoryOfCrypto>(),
          c<GetExchangeRatesUseCase>(),
          c<GetCryptoInfo>()));
  }

  @override
  void _configureRepo() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory<CryptoRepositiory>(
          (c) => CryptoRepositoryImpl(c<CryptoRemoteData>()))
      ..registerFactory((c) => CryptoRepositoryImpl(c<CryptoRemoteData>()));
  }

  @override
  void _configureUseCases() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => GetCryptoInfo(c<CryptoRepositiory>()))
      ..registerSingleton(
          (c) => GetExchangeRatesUseCase(c<CryptoRepositiory>()))
      ..registerSingleton((c) => GetHistoryOfCrypto(c<CryptoRepositiory>()))
      ..registerSingleton((c) => GetAllCryptos(c<CryptoRepositiory>()));
  }
}
