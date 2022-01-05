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


  List<String> cryptoList = ["ALGO", "ETH", "BTC"];
  
  String currency1 = 'ETH';
  String currency2 = 'ALGO';


  String amount = " ";
  String price = " ";
  UserTemp user = UserTemp();
  Tatum api = Tatum();

  String algoBalance = "";
  String etherBalance = "";

  @override
  void initState() {
    super.initState();
    
    useremail = auth.currentUser!.email!;
    buySellForm = BuySellForm(currency1: currency1, currency2: currency2);
    
    ordersForm = OrdersForm(currency1: currency1,currency2: currency2);
    chartForm = ChartForm(currency1: currency1,currency2: currency2);
    myOrdersForm = MyOrders();
    
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
                onChanged: (value) => setState(() {
                    buySellForm = BuySellForm(currency1: value!, currency2: buySellForm.currency2);
                    ordersForm = OrdersForm(currency1: buySellForm.currency1, currency2: buySellForm.currency2);
                    chartForm = ChartForm(currency1: buySellForm.currency1,currency2: buySellForm.currency2);
                  }),
            
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
                onChanged: (value) => setState(() {
                  
                    buySellForm = BuySellForm(currency1: buySellForm.currency1, currency2: value!);
                    ordersForm = OrdersForm(currency1: buySellForm.currency1, currency2: buySellForm.currency2);
                    chartForm = ChartForm(currency1: buySellForm.currency1, currency2: buySellForm.currency2);
                  }),
                
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


