import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class BarChartPage extends StatelessWidget {
  const BarChartPage({Key? key}) : super(key: key);

  Future<Map> getdata() async {
    Uri uri = Uri.parse(
        'http://api.coincap.io/v2/assets/bitcoin/history?interval=m1');
    final data = await http.get(uri, headers: {
      'Authorization': 'Bearer 7c8f5438-b7be-4186-a6ed-470d33ff9fb8'
    });
    final jsonData = jsonDecode(data.body);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 400,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: BarChart(
            BarChartData(
                backgroundColor: Colors.green.shade700,
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(
                      y: 5,
                      colors: [Colors.deepPurple],
                    )
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                      y: 7,
                      colors: [Colors.deepPurple],
                    )
                  ]),
                  BarChartGroupData(x: 60),
                  BarChartGroupData(x: 20),
                  BarChartGroupData(x: 20),
                ],
                barTouchData: BarTouchData(
                    touchTooltipData:
                        BarTouchTooltipData(tooltipBgColor: Colors.white))),
          ),
        ),
      ),
    );
  }
}
