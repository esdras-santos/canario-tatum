// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:canarioswap/tatum/tatum_api.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartForm extends StatefulWidget {
  ChartForm({ Key? key, required this.chartData}) : super(key: key);
  List<ChartData> chartData;

  @override
  _ChartFormState createState() => _ChartFormState();
}

class _ChartFormState extends State<ChartForm> {
  late TrackballBehavior _trackballBehavior;
  List<ChartData> _chartData = [];
  Tatum api = Tatum();

  @override
  void initState(){
    super.initState();
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    // getChartData().then((value) => _chartData = value);
    // updateTrades();
  }

  // Future updateTrades() async {
  //   while (true) {
  //     var value = await getChartData();
  //     setState(() {
  //       _chartData = value;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          const BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(5.0, 5.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Container(
        height: 380,
        width: 670,
        child: SfCartesianChart(
          trackballBehavior: _trackballBehavior,
          margin: EdgeInsets.only(right: 20, top: 15),
          series: <CandleSeries>[
            CandleSeries<ChartData, DateTime>(
                dataSource: widget.chartData,
                xValueMapper: (ChartData sales, _) => sales.x,
                lowValueMapper: (ChartData sales, _) => sales.low,
                highValueMapper: (ChartData sales, _) => sales.high,
                openValueMapper: (ChartData sales, _) => sales.open,
                closeValueMapper: (ChartData sales, _) => sales.close)
          ],
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(minimum: 70, maximum: 200, interval: 10),
        ),
      ),
    );
  }

  
}
class ChartData {
  final DateTime? x;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
  ChartData({this.x, this.open, this.close, this.low, this.high});
}