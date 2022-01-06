// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:canarioswap/screen/user/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:canarioswap/tatum/tatum_api.dart';
import 'appbar_components/appbar_rounded_button.dart';
import 'chart_components/forms/chart_form.dart';
import 'login.dart';
import 'my_orders_components/forms/my_orders.dart';
import 'orders_components/forms/orders_form.dart';
import 'trade_components.dart/forms/buy_sell_form.dart';
import 'wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';

class Trade extends StatefulWidget {
  const Trade({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  final auth = FirebaseAuth.instance;
  CollectionReference wallets =
      FirebaseFirestore.instance.collection('wallets');
  String useremail = " ";
  var buySellForm;
  var ordersForm;
  var chartForm;
  var myOrdersForm;

  // myorders
  List<Text> myOrdersPrice = [Text("Price"),];
  List<Text> myOrdersAmount = [Text("Amount"),];
  List<Text> myPairs = [Text("Pair"),];
  List<Text> myOrdersTypes = [Text("Type"),];
  List<Text> myOrdersTotal = [Text("Total")];
  List<String> ids = [];
  List<Widget> deleteButton = [SizedBox(height: 20,)];

  //orders
  List<Text> buyOrdersPrice = [];
  List<Text> buyOrdersAmount = [];
  List<Text> totalBuyOrdesAmount = [];
  List<Text> sellOrdersPrice = [];
  List<Text> sellOrdersAmount = [];
  List<Text> totalSellOrdersAmount = [];
  List<String> ordersids = [];
  var lastPrice = "0.0";
  TextStyle lastPriceStyle = TextStyle(color: Colors.green, fontSize: 14);

  // chart
  List<ChartData> chartData = [];

  List<String> cryptoList = ["ALGO", "ETH", "BTC"];
  
  String currency1 = 'ALGO';
  String currency2 = 'ETH';


  String amount = " ";
  String price = " ";
  UserTemp user = UserTemp();
  Tatum api = Tatum();

  String algoBalance = "";
  String etherBalance = "";


  @override
  void initState() {
    super.initState();
    buyOrdersPrice = [Text("price($currency1)", style: TextStyle(fontSize: 12)),];
    buyOrdersAmount = [Text("amount($currency2)", style: TextStyle(fontSize: 12)),];
    totalBuyOrdesAmount = [Text("total($currency1)", style: TextStyle(fontSize: 12)),];
    useremail = auth.currentUser!.email!;
    user.setExternalId(useremail);
    wallets.where(useremail).get().then((value) {
      var json = convert.jsonEncode(value.docs.asMap()[0]!.data());
      var wallet = convert.jsonDecode(json) as Map;
      user.initWallet(
        wallet[useremail]["secretAlgo"],
        wallet[useremail]["addressAlgo"],
        wallet[useremail]["mnemonicEth"],
        wallet[useremail]["xpubEth"],
        wallet[useremail]["customerId"]);
    });
    buySellForm = BuySellForm(currency1: currency1, currency2: currency2);
    
    ordersForm = OrdersForm(buyOrdersAmount: buyOrdersAmount, buyOrdersPrice: buyOrdersPrice, 
    totalBuyOrdesAmount: totalBuyOrdesAmount, sellOrdersAmount: sellOrdersAmount, sellOrdersPrice: sellOrdersPrice, 
    totalSellOrdersAmount: totalSellOrdersAmount, ids: ordersids, lastPrice: lastPrice, lastPriceStyle: lastPriceStyle,);

    chartForm = ChartForm(chartData: chartData);
    
    myOrdersForm = MyOrders(myOrdersPrice: myOrdersPrice, 
      myOrdersAmount: myOrdersAmount, myOrdersTotal: myOrdersTotal, 
      myOrdersTypes: myOrdersTypes, myPairs: myPairs, ids: ids, deleteButton: deleteButton);

    updateData();
    
  }

  Future updateData() async {
    while(true){
      try{
        await myOrdersList(user.accounts[0]["customerId"]);
        await priceAmountList();
        await getChartData();
      } on Exception catch(e){
        print(e);
      }
      
    }
  }

  Future priceAmountList() async {
    var lastPriceStyle = TextStyle(color: Colors.green, fontSize: 14);
    var buyJsonOrders = await api.openTrades("buy");
    
    var sellJsonOrders = await api.openTrades("sell");
    TextStyle style = TextStyle(color: Colors.green, fontSize: 12);
    if(buyJsonOrders.isEmpty && sellJsonOrders.isEmpty){
      setState(() {
        buyOrdersPrice = [Text("price(${currency1})", style: TextStyle(fontSize: 12)),];
        buyOrdersAmount = [Text("amount(${currency2})", style: TextStyle(fontSize: 12)),];
        totalBuyOrdesAmount = [Text("total(${currency1})", style: TextStyle(fontSize: 12)),];
        sellOrdersPrice = [];
        sellOrdersAmount = [];
        totalSellOrdersAmount = [];
        ids = [];
      });
    } else{
      if(!buyJsonOrders.isEmpty){
        for(Map order in buyJsonOrders){
          
          if(!ids.contains(order["id"])){
            if (order["pair"] == currency1 + "/" + currency2){
              setState(() {
                buyOrdersPrice.add(Text("${order["price"].length > 8 ? order["price"].substring(0,8): order["price"]}", style: style));
                buyOrdersAmount.add(Text("${order["amount"].length > 8 ? order["amount"].substring(0,8): order["amount"]}", style: style));
                var total = Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString()).toString();
                totalBuyOrdesAmount.add(Text("${total.length > 8 ? total.substring(0,8): total}", style: style));
                lastPrice = order["price"];
                lastPriceStyle = TextStyle(color: Colors.green, fontSize: 14);
                ids.add(order["id"]);
              });
            }
          }
        }
      }

      if(!sellJsonOrders.isEmpty){
        style = TextStyle(color: Colors.red, fontSize: 12);
        for(Map order in sellJsonOrders){
          if(!ids.contains(order["id"])){
            if (order["pair"] == currency1 + "/" + currency2){
              setState(() {
                sellOrdersPrice.add(Text("${order["price"].length > 8 ? order["price"].substring(0,8): order["price"]}", style: style));
                sellOrdersAmount.add(Text("${order["amount"].length > 8 ? order["amount"].substring(0,8): order["amount"]}", style: style));
                var total = Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString()).toString();
                totalSellOrdersAmount.add(Text("${total.length > 8 ? total.substring(0,8): total}", style: style));
                lastPrice = order["price"];
                lastPriceStyle = TextStyle(color: Colors.red, fontSize: 14);
                ids.add(order["id"]);
              });
            }
          }
        }
      }
    }
    setState(() {
      ordersForm = OrdersForm(buyOrdersAmount: buyOrdersAmount, buyOrdersPrice: buyOrdersPrice, 
        totalBuyOrdesAmount: totalBuyOrdesAmount, sellOrdersAmount: sellOrdersAmount, sellOrdersPrice: sellOrdersPrice, 
        totalSellOrdersAmount: totalSellOrdersAmount, ids: ordersids, lastPrice: lastPrice, lastPriceStyle: lastPriceStyle,);
    });
  }

  Future getChartData() async {
    DateTime now = DateTime.now();
    var date = DateTime.utc(now.year, now.month, now.day);
    List<ChartData> chartList = [];
    var charts = await api.chart(currency1 + "/" + currency2,
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

    setState(() {
      chartForm = ChartForm(chartData: chartData,);      
    });

  }


  Future myOrdersList(String id) async {
    
    var buyJsonOrders = await api.myOpenTrades(id, "buy");
      var sellJsonOrders = await api.myOpenTrades(id, "sell");
      if(buyJsonOrders.isEmpty && sellJsonOrders.isEmpty){
        setState((){
          myOrdersPrice = [Text("Price"),];
          myOrdersAmount = [Text("Amount"),];
          myPairs = [Text("Pair"),];
          myOrdersTypes = [Text("Type"),];
          myOrdersTotal = [Text("Total")];
          ordersids = [];
          deleteButton = [SizedBox(height: 20,)];
        });
      } else {
        if(!buyJsonOrders.isEmpty){
          for (Map order in buyJsonOrders){
            if(!ordersids.contains(order["id"])){
              setState(() {
                myOrdersPrice.add(Text("${order["price"].length > 8 ? order["price"].substring(0,8): order["price"]}",
                          style: TextStyle(color: Colors.green)));
                myOrdersAmount.add(Text("${order["amount"].length > 8 ? order["amount"].substring(0,8): order["amount"]}",
                        style: TextStyle(color: Colors.green)));
                myOrdersTypes.add(Text("${order["type"]}",
                        style: TextStyle(color: Colors.green)));
                var total = Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString()).toString();
                myOrdersTotal.add(Text("${total.length > 8 ? total.substring(0,8): total}",
                        style: TextStyle(color: Colors.green)));
                myPairs.add(
                      Text("${order["pair"]}", style: TextStyle(color: Colors.black)));
                deleteButton.add(cancelButton(order["id"]));
                ordersids.add(order["id"]);
              });
            } 
          }
        } 
        if(!sellJsonOrders.isEmpty){
          for(Map order in sellJsonOrders){
            if(!ordersids.contains(order["id"])){
              setState(() {
                myOrdersPrice.add(Text("${order["price"].length > 8 ? order["price"].substring(0,8): order["price"]}",
                          style: TextStyle(color: Colors.red)));
                myOrdersAmount.add(Text("${order["amount"].length > 8 ? order["amount"].substring(0,8): order["amount"]}",
                        style: TextStyle(color: Colors.red)));
                myOrdersTypes.add(Text("${order["type"]}",
                        style: TextStyle(color: Colors.red)));
                var total = Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString()).toString();
                myOrdersTotal.add(Text("${total.length > 8 ? total.substring(0,8): total}",
                        style: TextStyle(color: Colors.red)));
                myPairs.add(
                      Text("${order["pair"]}", style: TextStyle(color: Colors.black)));
                deleteButton.add(cancelButton(order["id"]));
                ordersids.add(order["id"]);
              });
            } 
          }
        }  
      }

      setState(() {
          myOrdersForm = MyOrders(myOrdersPrice: myOrdersPrice, 
            myOrdersAmount: myOrdersAmount, myOrdersTotal: myOrdersTotal, 
            myOrdersTypes: myOrdersTypes, myPairs: myPairs, ids: ordersids, deleteButton: deleteButton);
      });
    
  }

  Widget cancelButton(String id){
    var myId = id;
    return IconButton(
      iconSize: 20,
      icon: Icon(Icons.cancel),
      color: Colors.black,
      onPressed: () {
        
        api.deleteTrade(myId);
      },
    );
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
            leading: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text("LogOut"),
                              Icon(
                                Icons.logout,
                                color: Colors.green,
                              )
                            ]),
                        onTap: () {
                          auth.signOut().then((_) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              ));
                        },
                      ),
                    ],
                  child: Icon(Icons.menu, color: Colors.green))),
            actions: <Widget>[
              AppbarRoundedButton(title: "Trade", onTap: (){}),
              SizedBox(width: 20,),
              AppbarRoundedButton(title: "Wallet", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Wallet()),
                    );
                  },
                ),
              SizedBox(width: 20,),
            ]),
        body: Column(
          children: [
            Row(children: [
              SizedBox(width: 20),
              Text("Pair",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(width: 20),
              DropdownButton<String>(
                value: buySellForm.currency1,
                items: cryptoList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    buySellForm = BuySellForm(currency1: value!, currency2: buySellForm.currency2);
                    ordersForm = OrdersForm(buyOrdersAmount: buyOrdersAmount, buyOrdersPrice: buyOrdersPrice, 
                      totalBuyOrdesAmount: totalBuyOrdesAmount, sellOrdersAmount: sellOrdersAmount, sellOrdersPrice: sellOrdersPrice, 
                      totalSellOrdersAmount: totalSellOrdersAmount, ids: ordersids, lastPrice: lastPrice, lastPriceStyle: lastPriceStyle,);
                    chartForm = ChartForm(chartData: chartData);
                  });
                }
              ),
              Text(" / "),
              DropdownButton<String>(
                value: buySellForm.currency2,
                items: cryptoList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                  
                    buySellForm = BuySellForm(currency1: buySellForm.currency1, currency2: value!);
                    ordersForm = OrdersForm(buyOrdersAmount: buyOrdersAmount, buyOrdersPrice: buyOrdersPrice, 
                      totalBuyOrdesAmount: totalBuyOrdesAmount, sellOrdersAmount: sellOrdersAmount, sellOrdersPrice: sellOrdersPrice, 
                      totalSellOrdersAmount: totalSellOrdersAmount, ids: ordersids, lastPrice: lastPrice, lastPriceStyle: lastPriceStyle,);
                    chartForm = ChartForm(chartData: chartData);
                  });
                }
              ),
              Text(useremail),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        // charts
                        chartForm,
                        // orders of buy/sell
                        ordersForm,
                      ],
                    ),
                    // your open buy/sell orders
                    myOrdersForm,
                  ],
                ),
                // buy/sell
                buySellForm,
              ],
            ),
            
            
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
          Colors.green,
          Colors.yellow,
          Colors.green,
        ],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style),
    );
  }
  
}



