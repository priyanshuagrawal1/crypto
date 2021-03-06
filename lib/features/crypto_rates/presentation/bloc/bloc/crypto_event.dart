part of 'crypto_bloc.dart';

@immutable
abstract class CryptoEvent {}

class GetAllCryptosEvent extends CryptoEvent {}

class GetCryptoHistoryByName extends CryptoEvent {
  final String name;
  final String interval;

  GetCryptoHistoryByName({
    required this.name,
    this.interval = 'm1',
  });
}

class ChangeInterval extends CryptoEvent {
  final String interval;
  final String name;

  ChangeInterval({
    required this.interval,
    required this.name,
  });
}

class GetCryptoInfoEvent extends CryptoEvent {
  final String id;

  GetCryptoInfoEvent(this.id);
}

class GetExchangeRates extends CryptoEvent {}

class ChangeRate extends CryptoEvent {
  final Map<String, dynamic> rates;
  final String currency;

  ChangeRate({
    required this.rates,
    this.currency = 'USD',
  });
}

class GetTopCryptos extends CryptoEvent {}
