import 'package:crypto_book/core/di/injector.config.dart';
import 'package:crypto_book/core/di/injector.dart';
import 'package:crypto_book/features/crypto_rates/presentation/pages/top_gainers.dart';
import 'package:crypto_book/features/crypto_rates/presentation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/crypto_rates/presentation/bloc/bloc/crypto_bloc.dart';
import 'features/crypto_rates/presentation/pages/line_chart.dart';

void main() {
  InjectorConfig.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Injector.resolve<CryptoBloc>(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LineChartPage(),
        routes: {
          topGainersRoute: (ctx) => const TopGainers(),
          lineChartRoute: (ctx) => const LineChartPage()
        },
      ),
    );
  }
}
