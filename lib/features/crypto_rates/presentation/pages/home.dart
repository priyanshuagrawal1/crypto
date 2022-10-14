import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> getData() async {
    Uri url = Uri.parse('http://localhost:3000/api');
    String encode = jsonEncode(<String, String>{'name': 'ffff'});
    final response = await http.post(
      url,
      body: encode,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              Map data = snapshot.data as Map;
              return SizedBox(
                child: Text(data['name']),
              );
            }),
      ),
    );
  }
}
