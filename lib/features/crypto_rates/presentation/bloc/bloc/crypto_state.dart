part of 'crypto_bloc.dart';

@immutable
abstract class CryptoState {}

class CryptoInitial extends CryptoState {}

class ALlCryptos extends CryptoState {
  final List<Crypto> cryptos;

  ALlCryptos(this.cryptos);
}

class PriceHistoryOfCrypto extends CryptoState {
  final CryptoPriceHistory cryptoPriceHistory;
  final String interval;

  PriceHistoryOfCrypto(this.cryptoPriceHistory, this.interval);
}

class ConversionRates extends CryptoState {
  final Map<String, dynamic> rates;

  ConversionRates(this.rates);
}

class NewRate extends CryptoState {
  final double rate;

  NewRate(this.rate);
}
