import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../domain/entities/crypto.dart';
import '../bloc/bloc/crypto_bloc.dart';
import '../widgets/search.dart';

// ignore: must_be_immutable
class LineChartPage extends StatefulWidget {
  const LineChartPage({Key? key}) : super(key: key);

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  Future<Map> getdata({String crypto = 'bitcoin'}) async {
    Uri uri = Uri.parse(
        'http://api.coincap.io/v2/assets/bitcoin/history?interval=m15');
    final data = await http.get(uri, headers: {
      'Authorization': 'Bearer 7c8f5438-b7be-4186-a6ed-470d33ff9fb8'
    });
    Map jsonData = jsonDecode(data.body);
    return jsonData;
  }

  late TooltipBehavior _tooltipBehavior;

  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
    );
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      BlocProvider.of<CryptoBloc>(context).add(GetExchangeRates());
      BlocProvider.of<CryptoBloc>(context).add(GetAllCryptosEvent());
    });
  }

  Map<String, dynamic> conversionRates = {};
  double conversionRate = 1;
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cryptos = [];
    List<Crypto> cryptoList = [];
    String cryptoName = '';
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          actions: [
            BlocConsumer<CryptoBloc, CryptoState>(
              listener: (context, state) {
                if (state is ALlCryptos) {
                  cryptoList = state.cryptos;

                  BlocProvider.of<CryptoBloc>(context)
                      .add(GetCryptoHistoryByName(name: 'bitcoin'));
                }
              },
              bloc: BlocProvider.of<CryptoBloc>(context),
              builder: (context, state) {
                String interval = 'd1';
                if (state is PriceHistoryOfCrypto) {
                  interval = state.interval;
                }
                return IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: CryptoSearch(
                            cryptos: cryptoList,
                            interval: interval,
                          ));
                    },
                    icon: const Icon(Icons.search));
              },
            )
          ],
          bottom: TabBar(
            onTap: (i) {
              List names = ['m1', 'm15', 'h1', 'h6', 'h12'];
              BlocProvider.of<CryptoBloc>(context).add(
                  GetCryptoHistoryByName(interval: names[i], name: cryptoName));
            },
            tabs: const [
              Tab(text: '1D'),
              Tab(text: '7D'),
              Tab(text: '1M'),
              Tab(text: '6M'),
              Tab(text: '1Y'),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            for (var i = 0; i < 5; i++)
              Column(
                children: [
                  BlocBuilder<CryptoBloc, CryptoState>(
                    bloc: BlocProvider.of<CryptoBloc>(context),
                    builder: (context, state) {
                      if (state is PriceHistoryOfCrypto) {
                        cryptos = state.cryptoPriceHistory.priceHistory;
                        cryptoName = state.cryptoPriceHistory.name;
                      }
                      if (state is ALlCryptos) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is NewRate) {
                        conversionRate = state.rate;
                      }
                      return Column(
                        children: [
                          Text(
                            toBeginningOfSentenceCase(cryptoName)!,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SfCartesianChart(
                            tooltipBehavior: _tooltipBehavior,
                            zoomPanBehavior: _zoomPanBehavior,
                            primaryXAxis: DateTimeAxis(),
                            primaryYAxis: NumericAxis(),
                            series: <
                                ChartSeries<Map<String, dynamic>, DateTime>>[
                              LineSeries(
                                  animationDelay: 10,
                                  animationDuration: 400,
                                  color: Colors.red,
                                  dataSource: cryptos,
                                  xValueMapper:
                                      (Map<String, dynamic> crypto, _) {
                                    return crypto['time'];
                                  },
                                  yValueMapper:
                                      (Map<String, dynamic> crypto, _) =>
                                          double.parse(
                                            crypto['price'],
                                          ) *
                                          conversionRate,
                                  yAxisName: 'Usd'),
                            ],
                          ),
                          TextDropdownFormField(
                            options: conversionRates.keys.toList(),
                            onChanged: (String str) {
                              print(str);
                              BlocProvider.of<CryptoBloc>(context)
                                  .add(ChangeRate(conversionRates, str));
                            },
                          )
                        ],
                      );
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class CryptoData {
  final DateTime dateTime;
  final double price;

  const CryptoData(this.dateTime, this.price);
}
