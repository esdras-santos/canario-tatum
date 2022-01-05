import 'package:canarioswap/tatum/tatum_api.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

class OrdersForm extends StatefulWidget {
  OrdersForm({ Key? key, required this.currency1, required this.currency2 }) : super(key: key);
  String currency1;
  String currency2;
  @override
  _OrdersFormState createState() => _OrdersFormState();
}

class _OrdersFormState extends State<OrdersForm> {

  @override
  void initState(){
    super.initState();
    buyOrdersPrice = [Text("price(${widget.currency1})", style: TextStyle(fontSize: 12)),];
    buyOrdersAmount = [Text("amount(${widget.currency2})", style: TextStyle(fontSize: 12)),];
    totalBuyOrdesAmount = [Text("total(${widget.currency1})", style: TextStyle(fontSize: 12)),];
    priceAmountList("buy");
    priceAmountList("sell");
    updateTrades();
  }
  Tatum api = Tatum();
  List<Text> buyOrdersPrice = [];
  List<Text> buyOrdersAmount = [];
  List<Text> totalBuyOrdesAmount = [];
  List<Text> sellOrdersPrice = [];
  List<Text> sellOrdersAmount = [];
  List<Text> totalSellOrdesAmount = [];
  List<String> ids = [];

  Future updateTrades() async {
    while (true) {
      await priceAmountList('buy');
      await priceAmountList('sell');
    }
  }

  Future priceAmountList(String type) async {
    
    var jsonOrders = await api.openTrades(type);
    TextStyle style = TextStyle(color: Colors.green, fontSize: 12);;
    
    if (type == 'buy') {
      style = TextStyle(color: Colors.green, fontSize: 12);
    } else if (type == 'sell') {
      style = TextStyle(color: Colors.red, fontSize: 12);
    }
    
    for (Map order in jsonOrders) {
      if(!ids.contains(order["id"])){
        
        if (order["pair"] == widget.currency1 + "/" + widget.currency2) {
          if(order["type"] == 'BUY'){
            setState(() {
              buyOrdersPrice.add(Text("${order["price"]}", style: style));
              buyOrdersAmount.add(Text("${order["amount"]}", style: style));
              totalBuyOrdesAmount.add(Text("${Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString())}", style: style));
            });
          } else if (order["type"] == 'SELL'){
            setState(() {
              sellOrdersPrice.add(Text("${order["price"]}", style: style));
              sellOrdersAmount.add(Text("${order["amount"]}", style: style));
              totalSellOrdesAmount.add(Text("${Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString())}", style: style));
            });
          }
          
        }
        ids.add(order["id"]);
      }
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
              
              Container(
                height: 165,
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: buyOrdersPrice,
                    ),
                    Column(
                      children: buyOrdersAmount,
                    ),
                    Column(
                      children: totalBuyOrdesAmount,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 20,
                  width: 300,
                  child: Text("0.000000", style: TextStyle(fontSize: 14),)
                ),
              ),
              Container(
                height: 165,
                width: 300,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      sellOrdersPrice.length > 0
                          ? Column(
                              children: sellOrdersPrice,
                            )
                          : Container(),
                      sellOrdersAmount.length > 0
                          ? Column(
                              children: sellOrdersAmount,
                            )
                          : Container(),
                      totalSellOrdesAmount.length > 0
                        ? Column(
                            children: totalSellOrdesAmount,
                          )
                        : Container(),
                    ]),
              ),
            ],
          )),
    );
  }
}