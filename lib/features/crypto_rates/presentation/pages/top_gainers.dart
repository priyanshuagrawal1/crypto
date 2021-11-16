import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';
import 'package:crypto_book/features/crypto_rates/presentation/bloc/bloc/crypto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopGainers extends StatelessWidget {
  const TopGainers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as Map;
    List<Crypto> cryptos = argument['cryptos'];
    String operation = argument['operation'];
    Color color = operation == '-' ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          operation == '+' ? 'Top Gainers' : 'Top Losers',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<CryptoBloc>(context).add(GetAllCryptosEvent());
          BlocProvider.of<CryptoBloc>(context).add(GetTopCryptos());
        },
        child: SingleChildScrollView(
          child: BlocBuilder<CryptoBloc, CryptoState>(
            bloc: BlocProvider.of<CryptoBloc>(context),
            builder: (context, state) {
              if (state is TopCryptos) {
                if (operation == '-') {
                  cryptos = state.lastCryptos;
                } else {
                  cryptos = state.topCryptos;
                }
              }
              return DataTable(
                columns: const [
                  DataColumn(
                      label: Text(
                    'Crypto',
                    style: TextStyle(fontSize: 18.2),
                  )),
                  DataColumn(
                      label: Text(
                    'Value(\$)',
                    style: TextStyle(fontSize: 18.2),
                  )),
                  DataColumn(
                    label: SizedBox(
                      width: 200,
                      child: Text(
                        'Change %',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18.2),
                      ),
                    ),
                  ),
                ],
                columnSpacing: 35,
                rows: cryptos
                    .map(
                      (crypto) => DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                                width: 120,
                                child: Text(
                                  crypto.name,
                                  style: const TextStyle(fontSize: 17),
                                )),
                          ),
                          DataCell(
                            Text(
                              crypto.price.toStringAsFixed(4),
                              style: const TextStyle(fontSize: 16),
                            ),
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
                                  (operation == '-'
                                      ? (crypto.price *
                                              crypto.change /
                                              (100 - crypto.change))
                                          .toStringAsFixed(2)
                                      : '+' +
                                          (crypto.price *
                                                  crypto.change /
                                                  (100 + crypto.change))
                                              .toStringAsFixed(4)),
                                  style: TextStyle(color: color),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
