import 'dart:convert';
import 'dart:developer';

import 'package:crypto_book/features/crypto_rates/data/models/crypto_model.dart';
import 'package:crypto_book/features/crypto_rates/data/models/crypto_price_history_model.dart';
import 'package:http/http.dart' as http;

abstract class CryptoRemoteData {
  Future<List<CryptoModel>> getAllCrypto();
  Future<CryptoPriceHistoryModel> getHistoryOfCrypto(
      String name, String interval);
  Future<Map<String, dynamic>> getExchangeRates();
  Future<CryptoModel> getCryptoInfo(String id);
}

class CryptoRemoteDataImpl extends CryptoRemoteData {
  @override
  Future<List<CryptoModel>> getAllCrypto() async {
    try {
      Uri url = Uri.parse('http://api.coincap.io/v2/assets?limit=900');
      final http.Response data = await http.get(url, headers: {
        'Authorization': 'Bearer 7c8f5438-b7be-4186-a6ed-470d33ff9fb8',
      });
      Map jsonData = jsonDecode(data.body);
      List cryptosData = jsonData['data'];
      List<CryptoModel> cryptos = [];

      cryptos = cryptosData
          .map(
            (e) => CryptoModel.fromJson(e),
          )
          .toList();
      return cryptos;
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<CryptoPriceHistoryModel> getHistoryOfCrypto(
      String name, String interval) async {
    Uri url = Uri.parse(
        'http://api.coincap.io/v2/assets/$name/history?interval=$interval');
    final http.Response data = await http.get(url, headers: {
      'Authorization': 'Bearer 7c8f5438-b7be-4186-a6ed-470d33ff9fb8',
    });
    final cryptoData = jsonDecode(data.body);
    final List dataList = cryptoData['data'];
    final cryptoHistory = CryptoPriceHistoryModel(
      name: name,
      priceHistory: dataList
          .map((data) => {
                'price': data['priceUsd'] as String,
                'time': DateTime.fromMillisecondsSinceEpoch(data['time']),
              })
          .toList(),
    );
    return cryptoHistory;
  }

  @override
  Future<Map<String, dynamic>> getExchangeRates() async {
    Uri url = Uri.parse(
        'https://v6.exchangerate-api.com/v6/6a46ff5c75493b38008921e8/latest/USD');
    final response = await http.get(url);
    final Map responsebody = json.decode(response.body);
    return responsebody['conversion_rates'];
  }

  @override
  Future<CryptoModel> getCryptoInfo(String id) async {
    Uri url = Uri.parse('http://api.coincap.io/v2/assets/$id');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer 7c8f5438-b7be-4186-a6ed-470d33ff9fb8',
    });
    final responseBody = jsonDecode(response.body);
    return CryptoModel.fromJson(responseBody['data']);
  }
}
