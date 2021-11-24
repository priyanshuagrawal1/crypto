import 'dart:convert';

import 'package:crypto_book/features/crypto_rates/presentation/routes.dart';
import 'package:crypto_book/features/crypto_rates/presentation/widgets/custom_drawer.dart';
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

class _LineChartPageState extends State<LineChartPage>
    with SingleTickerProviderStateMixin {
  late TooltipBehavior _tooltipBehavior;
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late CrosshairBehavior _crosshairBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _crosshairBehavior = CrosshairBehavior(
        lineColor: Colors.red,
        lineDashArray: <double>[5, 5],
        lineWidth: 2,
        lineType: CrosshairLineType.vertical,
        activationMode: ActivationMode.singleTap,
        enable: true);
    _trackballBehavior = TrackballBehavior(
        tooltipAlignment: ChartAlignment.near,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        enable: true,
        tooltipSettings:
            const InteractiveTooltip(enable: true, color: Colors.red));
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

  Map<String, dynamic> conversionRates = {'': ''};
  double conversionRate = 1;
  List<Crypto> topCryptos = [];
  List<Crypto> lastCryptos = [];
  List<GlobalKey<RefreshIndicatorState>> refreshKey =
      [1, 2, 3, 4, 5].map((e) => GlobalKey<RefreshIndicatorState>()).toList();

  String roundToFirst(double num) {
    String numString = num.toString();
    List splits = numString.split('.');
    String decimalPart = splits[1];
    for (int i = 0; i < decimalPart.length; i++) {
      if (decimalPart[i] != '0') {
        if (i < 2) {
          return '${splits[0]}.${decimalPart.substring(0, 2)}';
        }
        return '${splits[0]}.${decimalPart.substring(0, i + 1)}';
      }
    }
    return '00';
  }

  String cryptoName = '';
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cryptos = [];
    List<Crypto> cryptoList = [];
    Crypto? crypto;
    double changeAmt = 0;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: BlocBuilder<CryptoBloc, CryptoState>(
          bloc: BlocProvider.of<CryptoBloc>(context),
          builder: (context, state) {
            if (state is TopCryptos) {
              lastCryptos = state.lastCryptos;
              topCryptos = state.topCryptos;
            }
            return customDrawer(context, topCryptos, lastCryptos);
          },
        ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 1,
          backgroundColor: Colors.white,
          title: BlocBuilder<CryptoBloc, CryptoState>(
              bloc: BlocProvider.of<CryptoBloc>(context),
              builder: (context, state) {
                String currency = 'USD';
                if (state is ConversionRates) {
                  conversionRates = state.rates;
                  BlocProvider.of<CryptoBloc>(context).add(
                    ChangeRate(rates: conversionRates, currency: 'USD'),
                  );
                }
                if (state is NewRate) {
                  currency = state.currency;
                }
                return SizedBox(
                  width: 200,
                  child: DropdownButtonFormField(
                    menuMaxHeight: 400,
                    onChanged: (dynamic str) =>
                        BlocProvider.of<CryptoBloc>(context).add(
                      ChangeRate(rates: conversionRates, currency: str),
                    ),
                    items: conversionRates.keys
                        .map((e) => DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e,
                            ))
                        .toList(),
                  ),
                );
              }),
          actions: [
            BlocConsumer<CryptoBloc, CryptoState>(
              listener: (context, state) {
                if (state is ALlCryptos) {
                  cryptoList = state.cryptos;
                  BlocProvider.of<CryptoBloc>(context)
                      .add(GetCryptoHistoryByName(name: 'bitcoin'));

                  BlocProvider.of<CryptoBloc>(context).add(GetTopCryptos());
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
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ));
              },
            )
          ],
          bottom: TabBar(
            isScrollable: false,
            onTap: (i) {
              List names = ['m1', 'm15', 'h1', 'h6', 'h12'];
              BlocProvider.of<CryptoBloc>(context).add(
                  GetCryptoHistoryByName(interval: names[i], name: cryptoName));
            },
            tabs: const [
              Tab(child: Text('1D', style: TextStyle(color: Colors.black))),
              Tab(child: Text('7D', style: TextStyle(color: Colors.black))),
              Tab(child: Text('1M', style: TextStyle(color: Colors.black))),
              Tab(child: Text('6M', style: TextStyle(color: Colors.black))),
              Tab(child: Text('1Y', style: TextStyle(color: Colors.black))),
            ],
            indicatorColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            for (var i = 0; i < 5; i++)
              BlocBuilder<CryptoBloc, CryptoState>(
                bloc: BlocProvider.of<CryptoBloc>(context),
                builder: (context, state) {
                  // print(state);
                  if (state is TopCryptos) {
                    topCryptos = state.topCryptos;
                    lastCryptos = state.lastCryptos;
                  }
                  if (state is PriceHistoryOfCrypto) {
                    cryptos = state.cryptoPriceHistory.priceHistory;
                    cryptoName = state.cryptoPriceHistory.name;
                    crypto = state.cryptoDetails;
                    changeAmt = (crypto!.price *
                        crypto!.change /
                        (100 - crypto!.change));
                  }
                  if (state is ALlCryptos) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is NewRate) {
                    conversionRate = state.rate;
                  }
                  if (crypto == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      BlocProvider.of<CryptoBloc>(context)
                          .add(GetAllCryptosEvent());
                    },
                    key: refreshKey[i],
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            toBeginningOfSentenceCase(cryptoName)!,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SfCartesianChart(
                            crosshairBehavior: _crosshairBehavior,
                            trackballBehavior: _trackballBehavior,
                            tooltipBehavior: _tooltipBehavior,
                            zoomPanBehavior: _zoomPanBehavior,
                            primaryXAxis: DateTimeAxis(),
                            primaryYAxis: NumericAxis(
                              opposedPosition: true,
                              interactiveTooltip:
                                  const InteractiveTooltip(enable: true),
                            ),
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
                          DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  toBeginningOfSentenceCase(cryptoName)!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                  label: Text(
                                'Data',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ))
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(biggerBolderText('Rank')),
                                DataCell(
                                    biggerBolderText(crypto!.rank.toString()))
                              ]),
                              DataRow(cells: [
                                DataCell(biggerBolderText('Symbol')),
                                DataCell(biggerBolderText(crypto!.symbol))
                              ]),
                              DataRow(cells: [
                                DataCell(biggerBolderText('Price USD')),
                                DataCell(biggerBolderText(
                                    '\$${crypto!.price.toStringAsFixed(2)}'))
                              ]),
                              DataRow(cells: [
                                DataCell(biggerBolderText('Change')),
                                DataCell(
                                  Text(
                                    '${roundToFirst(changeAmt)}(${crypto!.change.toStringAsFixed(2)})',
                                    style: TextStyle(
                                        color: crypto!.change < 0
                                            ? Colors.red
                                            : Colors.green,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ]),
                              DataRow(cells: [
                                DataCell(biggerBolderText('Supply')),
                                DataCell(biggerBolderText(
                                    crypto!.supply.toStringAsFixed(2)))
                              ]),
                            ],
                          ),
                          topAndLasts(
                              context: context,
                              cryptos: topCryptos,
                              topText: 'Top Gainers',
                              color: Colors.green,
                              operation: '+'),
                          topAndLasts(
                              context: context,
                              cryptos: lastCryptos.toList(),
                              topText: 'Top Losers',
                              color: Colors.red,
                              operation: '-')
                        ],
                      ),
                    ),
                  );
                },
              )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Buy',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green, minimumSize: const Size(100, 50)),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Sell',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red, minimumSize: Size(100, 50)),
            ),
          ],
        ),
      ),
    );
  }

  Text biggerBolderText(String text) => Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      );

  Column topAndLasts({
    required BuildContext context,
    required List<Crypto> cryptos,
    required String topText,
    required Color color,
    required String operation,
  }) {
    List hotCryptos = [];
    if (cryptos.isNotEmpty) {
      hotCryptos = cryptos.sublist(0, 5);
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              topText,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(topGainersRoute,
                  arguments: {'cryptos': cryptos, 'operation': operation}),
              child: const Text(
                'View All',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        DataTable(
          columns: const [
            DataColumn(
                label: Text(
              'Crypto',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 19.2,
              ),
            )),
            DataColumn(
                label: Text(
              'value',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 19.2,
              ),
            )),
            DataColumn(
              label: SizedBox(
                width: 120,
                child: Text(
                  'change %',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18.2),
                ),
              ),
            ),
          ],
          rows: hotCryptos
              .map(
                (crypto) => DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                          width: 120,
                          child: Text(
                            crypto.name,
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    DataCell(
                      Text(crypto.price.toStringAsFixed(5)),
                    ),
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            crypto.change.toStringAsFixed(2) + '%',
                            style: TextStyle(color: color),
                          ),
                          Text(
                            roundToFirst(operation == '-'
                                ? crypto.price *
                                    crypto.change /
                                    (100 - crypto.change)
                                : crypto.price *
                                    crypto.change /
                                    (100 + crypto.change)),
                            style: TextStyle(color: color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class CryptoData {
  final DateTime dateTime;
  final double price;

  const CryptoData(this.dateTime, this.price);
}
