import 'package:crypto_book/features/crypto_rates/domain/entities/crypto.dart';
import 'package:crypto_book/features/crypto_rates/presentation/bloc/bloc/crypto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoSearch extends SearchDelegate {
  late List<Crypto> cryptos;
  late String interval;
  CryptoSearch({
    required this.cryptos,
    required this.interval,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItems = cryptos
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchItems.length,
      itemBuilder: (ctx, index) {
        return ListTile(
            title: Text(searchItems[index].name),
            subtitle: Text(searchItems[index].price.toString()),
            leading: Text(searchItems[index].symbol),
            onTap: () {
              BlocProvider.of<CryptoBloc>(context).add(GetCryptoHistoryByName(
                  name: searchItems[index].id, interval: interval));
              BlocProvider.of<CryptoBloc>(context)
                  .add(GetCryptoInfoEvent(searchItems[index].id));
              close(context, null);
            });
      },
    );
  }
}
