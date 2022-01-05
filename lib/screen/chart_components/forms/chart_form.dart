import 'package:canarioswap/tatum/tatum_api.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartForm extends StatefulWidget {
  ChartForm({ Key? key, required this.currency1, required this.currency2}) : super(key: key);
  String currency1;
  String currency2;

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
    getChartData().then((value) => _chartData = value);
    updateTrades();
  }

  Future updateTrades() async {
    while (true) {
      var value = await getChartData();
      setState(() {
        _chartData = value;
      });
    }
  }

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
                dataSource: _chartData,
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

  Future<List<ChartData>> getChartData() async {
    DateTime now = DateTime.now();
    var date = DateTime.utc(now.year, now.month, now.day);
    List<ChartData> chartList = [];
    var charts = await api.chart(widget.currency1 + "/" + widget.currency2,
        date.millisecondsSinceEpoch, date.millisecondsSinceEpoch, "DAY");
    for (Map d in charts) {
      chartList.add(
        ChartData(
            x: d["timestamp"],
            high: d["high"],
            low: d["low"],
            open: d["open"],
            close: d["close"]),
      );
    }

    return chartList;
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