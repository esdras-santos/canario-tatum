import 'package:canarioswap/screen/user/user.dart';
import 'package:flutter/material.dart';

import '../buy_rounded_button.dart';
import '../input_container.dart';
import '../sell_rounded_button.dart';

class BuySellForm extends StatefulWidget {
  const BuySellForm({Key? key}) : super(key: key);

  @override
  _BuySellFormState createState() => _BuySellFormState();
}

class _BuySellFormState extends State<BuySellForm> {
  bool buyon = true;
  bool sellon = false;

  var decisionButtonCollor = Colors.green[600];
  var decisionButtonLetter = Colors.white;
  var decisionText = "buy";
  
  UserTemp user = UserTemp();

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();
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
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      sellon = false;
                      buyon = true;
                      decisionButtonCollor = Colors.green[600];
                      decisionButtonLetter = Colors.white;
                      decisionText = "buy";
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.all(0.0),
                  child: buyon ? BuyRoundedButton(on: buyon) : BuyRoundedButton(on: buyon),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      sellon = true;
                      buyon = false;
                      decisionButtonCollor = Colors.red[600];
                      decisionButtonLetter = Colors.white;
                      decisionText = "sell";
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.all(0.0),
                  child: sellon ? SellRoundedButton(on: sellon) : SellRoundedButton(on: sellon),
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
            InputContainer(
              child: TextField(
                textAlign: TextAlign.right,
                controller: _controller,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.green),
                  hintText: "Price",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  user.order["price"] = value.trim();
                },
              ),
            ),
            SizedBox(height: 5),

          ],
        ),
      ),
    );
  }

  
}
