import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crypto_book/core/usecase/usecase.dart';
import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';
import 'package:crypto_book/features/crypto_rates/domain/entities/crypto_price_history.dart';
import 'package:crypto_book/features/crypto_rates/domain/use_cases/get_all_cryptos.dart';
import 'package:crypto_book/features/crypto_rates/domain/use_cases/get_crypto_info.dart';
import 'package:crypto_book/features/crypto_rates/domain/use_cases/get_exchange_rates.dart';
import 'package:crypto_book/features/crypto_rates/domain/use_cases/get_history_of_crypto.dart';

import 'package:meta/meta.dart';

part 'crypto_event.dart';
part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final GetAllCryptos _getAllCryptos;
  final GetHistoryOfCrypto _getHistoryOfCrypto;
  final GetExchangeRatesUseCase _getExchangeRates;
  final GetCryptoInfo _getCryptoInfo;
  CryptoBloc(
    GetAllCryptos getAllCryptos,
    GetHistoryOfCrypto getHistoryOfCrypto,
    GetExchangeRatesUseCase getExchangeRates,
    GetCryptoInfo getCryptoInfo,
  )   : _getAllCryptos = getAllCryptos,
        _getHistoryOfCrypto = getHistoryOfCrypto,
        _getExchangeRates = getExchangeRates,
        _getCryptoInfo = getCryptoInfo,
        super(CryptoInitial()) {
    on<GetAllCryptosEvent>((event, emit) async {
      try {
        final List<Crypto> cryptos = await _getAllCryptos(NoParam());
        emit(ALlCryptos(cryptos));
      } on Exception catch (e) {
        log(e.toString());
        rethrow;
      }
    });

    on<GetCryptoHistoryByName>(
      (event, emit) async {
        try {
          final CryptoPriceHistory cryptoHistory =
              await _getHistoryOfCrypto(SearchParam(
            event.name,
            interval: event.interval,
          ));
          final Crypto cryptoDetails =
              await _getCryptoInfo(CryptoInfoParams(event.name));
          emit(PriceHistoryOfCrypto(
              cryptoHistory, event.interval, cryptoDetails));
        } catch (e) {
          log(e.toString());
          rethrow;
        }
      },
    );

    on<GetTopCryptos>((event, emit) {
      List<Crypto> cryptos = state.cryptosInitial;
      List<Crypto> topCryptos =
          cryptos.where((element) => element.change > 0).toList();
      topCryptos.sort((a, b) => b.change.compareTo(a.change));
      List<Crypto> lastCryptos =
          cryptos.where((element) => element.change < 0).toList();
      lastCryptos.sort((a, b) => b.change.compareTo(a.change));
      emit(TopCryptos(
          topCryptos: topCryptos, lastCryptos: lastCryptos.reversed.toList()));
    });

    on<GetExchangeRates>((event, emit) async {
      try {
        final Map<String, dynamic> rates = await _getExchangeRates(NoParam());
        emit(ConversionRates(rates));
      } catch (e) {
        log(e.toString());
      }
    });
    on<ChangeRate>((event, emit) {
      double conversionRate = 1.0;
      conversionRate = double.parse(event.rates[event.currency].toString());
      emit(NewRate(conversionRate, event.currency));
    });
  }
}
