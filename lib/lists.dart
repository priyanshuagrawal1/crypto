import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Lists extends StatefulWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  Future<Map> getdata() async {
    Uri uri = Uri.parse(
        'http://api.coincap.io/v2/assets/bitcoin/history?interval=d1');
    final data = await http.get(uri, headers: {
      'Authorization': 'Bearer 7c8f5438-b7be-4186-a6ed-470d33ff9fb8'
    });
    final jsonData = jsonDecode(data.body);
    return jsonData;
  }

  late List data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: FutureBuilder(
          future: getdata(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Map snapData = snapshot.data! as Map;
              List data = snapData['data'] as List;
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      double price = double.parse(data[index]['priceUsd']);
                      return ListTile(
                        title: Text(DateTime.fromMillisecondsSinceEpoch(
                                data[index]['time'])
                            .day
                            .toString()),
                        subtitle: Text(price.toStringAsFixed(2)),
                      );
                    }),
              );
            }
          }),
    );
  }
}
