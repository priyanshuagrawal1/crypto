part of 'crypto_bloc.dart';

@immutable
abstract class CryptoState {
  final List<Crypto> cryptosInitial;

  const CryptoState({this.cryptosInitial = const []});
}

class CryptoInitial extends CryptoState {}

class CrytpoInfoState extends CryptoState {
  final Map cryptoInfo;

  const CrytpoInfoState(this.cryptoInfo);
}

class ALlCryptos extends CryptoState {
  final List<Crypto> cryptos;

  const ALlCryptos(this.cryptos) : super(cryptosInitial: cryptos);
}

class PriceHistoryOfCrypto extends CryptoState {
  final CryptoPriceHistory cryptoPriceHistory;
  final String interval;
  final Crypto cryptoDetails;

  const PriceHistoryOfCrypto(
      this.cryptoPriceHistory, this.interval, this.cryptoDetails);
}

class ConversionRates extends CryptoState {
  final Map<String, dynamic> rates;

  const ConversionRates(this.rates);
}

class NewRate extends CryptoState {
  final double rate;
  final String currency;

  const NewRate(this.rate, this.currency);
}

class TopCryptos extends CryptoState {
  final List<Crypto> topCryptos;
  final List<Crypto> lastCryptos;

  const TopCryptos({
    required this.topCryptos,
    required this.lastCryptos,
  });
}

class LastCryptos extends CryptoState {
  final List<Crypto> lastCryptos;

  const LastCryptos(this.lastCryptos);
}
