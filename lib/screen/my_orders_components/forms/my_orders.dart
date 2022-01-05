import 'package:canarioswap/screen/user/user.dart';
import 'package:canarioswap/tatum/tatum_api.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({ Key? key }) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Text> myOrdersPrice = [Text("Price"),];
  List<Text> myOrdersAmount = [Text("Amount"),];
  List<Text> myPairs = [Text("Pair"),];
  List<Text> myOrdersTypes = [Text("Type"),];
  List<Text> myOrdersTotal = [Text("Total")];
  List<String> ids = [""];

  UserTemp user = UserTemp();
  
  Tatum api = Tatum();

  @override
  void initState(){
    super.initState();
    myOrdersList(user.accounts[0]["customerId"], "buy");
    myOrdersList(user.accounts[0]["customerId"], "sell");
  }

  Future myOrdersList(String id, type) async {
    while(true){
      var jsonOrders = await api.myOpenTrades(id, type);

      for (Map order in jsonOrders) {
        if(!ids.contains(order["id"])){
          setState(() {
            if (order["type"] == 'BUY') {
              myOrdersPrice.add(Text("${order["price"]}",
                      style: TextStyle(color: Colors.green)));
              myOrdersAmount.add(Text("${order["amount"]}",
                      style: TextStyle(color: Colors.green)));
              myOrdersTypes.add(Text("${order["type"]}",
                      style: TextStyle(color: Colors.green)));
              myOrdersTotal.add(Text("${Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString())}",
                      style: TextStyle(color: Colors.green)));
              myPairs.add(
                    Text("${order["pair"]}", style: TextStyle(color: Colors.black)));
              
            } else if (order["type"] == 'SELL') {
              myOrdersPrice.add(Text("${order["price"]}",
                      style: TextStyle(color: Colors.red)));
              myOrdersAmount.add(Text("${order["amount"]}",
                      style: TextStyle(color: Colors.red)));
              myOrdersTypes.add(Text("${order["type"]}",
                      style: TextStyle(color: Colors.red)));
              myOrdersTotal.add(Text("${Decimal.parse((double.parse(order["amount"]) * double.parse(order["price"])).toString())}",
                      style: TextStyle(color: Colors.red)));
              myPairs.add(
                    Text("${order["pair"]}", style: TextStyle(color: Colors.black)));
              
            }
          });
          ids.add(order["id"]);
        }
               
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
              Column(
                children: myPairs,
              ),
              Column(
                children: myOrdersTypes,
              ),
              Column(
                children: myOrdersPrice,
              ),
              Column(
                children: myOrdersAmount,
              ),
              Column(
                children: myOrdersTotal,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}