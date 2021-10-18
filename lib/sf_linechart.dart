import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SfLinechartPage extends StatefulWidget {
  const SfLinechartPage({Key? key}) : super(key: key);

  @override
  _SfLinechartPageState createState() => _SfLinechartPageState();
}

class _SfLinechartPageState extends State<SfLinechartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(child: SfSparkLineChart()),
    );
  }
}
