import 'package:canarioswap/screen/user/user.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:canarioswap/tatum/tatum_api.dart';
import 'wallet.dart';

class Trade extends StatefulWidget {
  const Trade({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  // buy button state
  var buyCollor = Colors.green[600];
  var buyLetter = Colors.white;
  // sell button state
  var sellCollor = Colors.grey[200];
  var sellLetter = Colors.grey[600];

  var decisionButtonCollor = Colors.green[600];
  var decisionButtonLetter = Colors.white;
  var decisionText = "buy ";

  void setButton(String button, currency) {
    if (button == "buy") {
      setState(() {
        buyCollor = Colors.green[600]!;
        buyLetter = Colors.white;

        sellCollor = Colors.grey[200];
        sellLetter = Colors.grey[600];

        decisionButtonCollor = Colors.green[600];
        decisionButtonLetter = Colors.white;
        decisionText = "buy ";
      });
    } else {
      setState(() {
        buyCollor = Colors.grey[200];
        buyLetter = Colors.grey[600]!;

        sellCollor = Colors.orange[600];
        sellLetter = Colors.white;

        decisionButtonCollor = Colors.orange[600];
        decisionButtonLetter = Colors.white;
        decisionText = "sell ";
      });
    }
  }

  List<String> cryptoList = ["ALGO", "ETH", "BTC"];
  List<ListTile> buyOrdersPrice = [];
  List<ListTile> buyOrdersAmount = [];
  List<ListTile> sellOrdersPrice = [];
  List<ListTile> sellOrdersAmount = [];
  List<ListTile> myOrdersPrice = [];
  List<ListTile> myOrdersAmount = [];
  List<ListTile> myPairs = [];
  String currency1 = 'ALGO';
  String currency2 = 'BTC';

  late List<ChartData> _chartData;
  late TrackballBehavior _trackballBehavior;

  String amount = " ";
  String price = " ";
  User user = User();
  Tatum api = Tatum();

  @override
  void initState() {
    _chartData = getChartData();
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    priceAmountList('buy');
    priceAmountList('sell');
    myOrdersList("id");

    super.initState();
  }

  void myOrdersList(String id) async {
    var jsonOrders = await api.myOpenTrades(id);
    setState(() {
      myOrdersPrice = [];
      myOrdersAmount = [];
      myPairs = [];
    });

    List<ListTile> price = [];
    List<ListTile> amount = [];
    List<ListTile> pairs = [];
    for (Map order in jsonOrders) {
      if (order["type"] == 'BUY') {
        price.add(ListTile(
            title: Text("${order["price"]}",
                style: TextStyle(color: Colors.green))));
        amount.add(ListTile(
            title: Text("${order["amount"]}",
                style: TextStyle(color: Colors.green))));
      } else {
        price.add(ListTile(
            title: Text("${order["price"]}",
                style: TextStyle(color: Colors.red))));
        amount.add(ListTile(
            title: Text("${order["amount"]}",
                style: TextStyle(color: Colors.red))));
      }
      pairs.add(ListTile(
          title:
              Text("${order["pair"]}", style: TextStyle(color: Colors.black))));
    }
    setState(() {
      myOrdersPrice = price;
      myOrdersAmount = amount;
      myPairs = pairs;
    });
  }

  void priceAmountList(String type) async {
    var jsonOrders = await api.openTrades(type);
    TextStyle style;
    setState(() {
      buyOrdersAmount = [];
      buyOrdersPrice = [];
      sellOrdersAmount = [];
      sellOrdersPrice = [];
    });
    if (type == 'buy') {
      style = TextStyle(color: Colors.green);
    } else {
      style = TextStyle(color: Colors.red);
    }
    List<ListTile> price = [];
    List<ListTile> amount = [];
    for (Map order in jsonOrders) {
      if (order["pair"] == "$currency1" + "/" + "$currency2") {
        price.add(ListTile(title: Text("${order["price"]}", style: style)));
        amount.add(ListTile(title: Text("${order["amount"]}", style: style)));
      }
    }

    if (type == 'buy') {
      setState(() {
        buyOrdersAmount = amount;
        buyOrdersPrice = price;
      });
    } else {
      setState(() {
        sellOrdersAmount = amount;
        sellOrdersPrice = price;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: shader(
              "Canario",
              TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                child: Container(
                  height: 40,
                  width: 80,
                  child: RaisedButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      height: 45,
                      width: 85,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.yellow,
                              Colors.green,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Container(
                        width: 80,
                        height: 20,
                        constraints: BoxConstraints(
                            maxWidth: 80.0, minHeight: 10.0, maxHeight: 20),
                        alignment: Alignment.center,
                        child: Text(
                          "Trade",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Wallet()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.yellow,
                            Colors.green,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 100.0, minHeight: 20.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Wallet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
        body: Column(
          children: [
            Row(children: [
              SizedBox(width: 20),
              Text("Pair",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(width: 20),
              DropdownButton<String>(
                value: currency1,
                items: cryptoList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    currency1 = value!;
                  });
                  priceAmountList('buy');
                  priceAmountList('sell');
                },
              ),
              Text(" / "),
              DropdownButton<String>(
                value: currency2,
                items: cryptoList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    currency2 = value!;
                  });
                  priceAmountList('buy');
                  priceAmountList('sell');
                },
              ),
            ]),
            Row(
              children: [
                // charts
                chartsForm(),
                // orders of buy/sell
                ordersForms(),
                // buy/sell
                buyEndSellForm(),
              ],
            ),
            // your open buy/sell orders
            myOrdersForm(),
          ],
        ));
  }

  Widget shader(String text, TextStyle style) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.yellow,
          Colors.green,
        ],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style),
    );
  }

  Widget chartsForm() {
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

  Widget myOrdersForm() {
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
        height: 130,
        width: 600,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text("Pair"),
              Text("Price"),
              Text("Amount"),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              myPairs.length > 0
                  ? ListView(
                      children: myPairs,
                    )
                  : Container(),
              myOrdersPrice.length > 0
                  ? ListView(
                      children: myOrdersPrice,
                    )
                  : Container(),
              myOrdersAmount.length > 0
                  ? ListView(
                      children: myOrdersAmount,
                    )
                  : Container(),
            ]),
          ],
        ),
      ),
    );
  }

  Widget ordersForms() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(5.0, 5.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Container(
          height: 380,
          width: 300,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text("price($currency1)"),
                Text("amount($currency2)"),
              ]),
              Container(
                height: 165,
                width: 300,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buyOrdersPrice.length > 0
                          ? ListView(
                              children: buyOrdersPrice,
                            )
                          : Container(),
                      buyOrdersAmount.length > 0
                          ? ListView(
                              children: buyOrdersAmount,
                            )
                          : Container(),
                    ]),
              ),
              Container(
                height: 20,
                width: 300,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //this is just a mockup

                      Text("0.000000",
                          style: TextStyle(color: Colors.red, fontSize: 18)),

                      //this is just a mockup
                      Text("0.00000000",
                          style: TextStyle(color: Colors.red, fontSize: 18)),
                    ]),
              ),
              Container(
                height: 165,
                width: 300,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      sellOrdersPrice.length > 0
                          ? ListView(
                              children: sellOrdersPrice,
                            )
                          : Container(),
                      sellOrdersAmount.length > 0
                          ? ListView(
                              children: sellOrdersAmount,
                            )
                          : Container(),
                    ]),
              ),
            ],
          )),
    );
  }

  Widget buyEndSellForm() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(5.0, 5.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Container(
        height: 380,
        width: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: buyCollor),
                  onPressed: () {
                    setButton("buy", currency1);
                  },
                  child: Text(
                    "BUY",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: buyLetter),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: sellCollor),
                  onPressed: () {
                    setButton("sell", currency1);
                  },
                  child: Text(
                    "SELL",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: sellLetter),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(right: 300),
              child: Text("Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 270,
                  child: TextField(
                    onChanged: (value) {
                      price = value;
                    },
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: 'Price',
                    ),
                  ),
                ),
                Text(currency1, style: TextStyle(fontSize: 20))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(right: 280),
              child: Text("Amount",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 270,
                  child: TextField(
                    onChanged: (value) {
                      amount = value;
                    },
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: 'Amount',
                    ),
                  ),
                ),
                Text(currency2, style: TextStyle(fontSize: 20))
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: decisionButtonCollor),
              onPressed: () async {
                String id1 = ' ';
                String id2 = ' ';
                for (Map acc in user.accounts) {
                  if (acc["currency"] == currency1) {
                    id1 = acc["id"];
                  }
                  if (acc["currency"] == currency2) {
                    id2 = acc["id"];
                  }
                }
                await api.trade(id1, id2, price, amount, currency1+"/"+currency2,decisionText.toUpperCase());
              },
              child: Text(
                decisionText + currency1,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: decisionButtonLetter),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ChartData> getChartData() {
    return <ChartData>[
      ChartData(
        x: DateTime(2021, 12, 05),
        open: 115.8,
        high: 117.5,
        low: 105.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 06),
        open: 110.8,
        high: 118.5,
        low: 109.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 07),
        open: 111.8,
        high: 112.5,
        low: 105.59,
        close: 146.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 08),
        open: 175.8,
        high: 187.5,
        low: 175.59,
        close: 156.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 09),
        open: 115.8,
        high: 97.5,
        low: 95.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 10),
        open: 110.8,
        high: 95.5,
        low: 90.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 10),
        open: 111.8,
        high: 90.5,
        low: 85.59,
        close: 146.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 10),
        open: 175.8,
        high: 187.5,
        low: 175.59,
        close: 156.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 11),
        open: 115.8,
        high: 117.5,
        low: 105.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 12),
        open: 110.8,
        high: 118.5,
        low: 109.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 13),
        open: 111.8,
        high: 112.5,
        low: 105.59,
        close: 146.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 14),
        open: 175.8,
        high: 187.5,
        low: 175.59,
        close: 156.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 15),
        open: 115.8,
        high: 97.5,
        low: 95.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 16),
        open: 110.8,
        high: 95.5,
        low: 90.59,
        close: 116.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 17),
        open: 111.8,
        high: 90.5,
        low: 85.59,
        close: 146.52,
      ),
      ChartData(
        x: DateTime(2021, 12, 18),
        open: 175.8,
        high: 187.5,
        low: 175.59,
        close: 156.52,
      ),
    ];
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
