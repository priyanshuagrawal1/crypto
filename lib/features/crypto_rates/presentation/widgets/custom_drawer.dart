import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';
import 'package:crypto_book/features/crypto_rates/presentation/bloc/bloc/crypto_bloc.dart';
import 'package:crypto_book/features/crypto_rates/presentation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Drawer customDrawer(
    BuildContext context, List<Crypto> topCryptos, List<Crypto> lastCryptos) {
  return Drawer(
    child: ListView(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        ListTile(
          onTap: () => Navigator.of(context).pushNamed(lineChartRoute),
          leading: const Icon(Icons.home, size: 30),
          title: const Text(
            'Home',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        BlocListener<CryptoBloc, CryptoState>(
          bloc: BlocProvider.of<CryptoBloc>(context),
          listener: (context, state) {
            if (state is TopCryptos) {
              topCryptos = state.topCryptos;
            }
          },
          child: ListTile(
            onTap: () => Navigator.of(context).pushNamed(topGainersRoute,
                arguments: {'cryptos': topCryptos, 'operation': '+'}),
            leading: const Icon(Icons.arrow_upward, size: 30),
            title: const Text(
              'Top Gainers',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        BlocListener<CryptoBloc, CryptoState>(
          bloc: BlocProvider.of<CryptoBloc>(context),
          listener: (context, state) {
            if (state is TopCryptos) {
              lastCryptos = state.lastCryptos;
            }
          },
          child: ListTile(
            onTap: () => Navigator.of(context).pushNamed(topGainersRoute,
                arguments: {'cryptos': lastCryptos, 'operation': '-'}),
            leading: const Icon(Icons.arrow_downward, size: 30),
            title: const Text(
              'Top Losers',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    ),
  );
}
