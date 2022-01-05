import 'package:canarioswap/screen/user/user.dart';
import 'package:canarioswap/tatum/tatum_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import '../buy_rounded_button.dart';
import '../decision_button.dart';
import '../price_input_container.dart';
import '../sell_rounded_button.dart';

class BuySellForm extends StatefulWidget {
  String currency1;
  String currency2;
  BuySellForm({Key? key, required this.currency1, required this.currency2}) : super(key: key);

  @override
  _BuySellFormState createState() => _BuySellFormState();
}

class _BuySellFormState extends State<BuySellForm> {
  bool buyon = true;
  bool sellon = false;
  var total = 0.0;

  var decisionButtonCollor = Colors.green[600];
  var decisionButtonLetter = Colors.white;
  var decisionText = "buy";
  var pic;
  var amountController = TextEditingController();
  
  UserTemp user = UserTemp();
  Tatum api = Tatum();

  @override
  void initState(){
    super.initState();
    pic = PriceInputContainer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        height: 530,
        width: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Price(${widget.currency1})",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(height: 5),
            pic,
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Amount(${widget.currency2})",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.right,
                    controller: amountController,
                    // keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter(maxInputValue: double.parse(user.accounts[user.coins[widget.currency2]]["balance"]["availableBalance"])),
                    ],
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      hintText: "Amount",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState((){
                        user.order["amount"] = value.trim();
                        total = (double.parse(user.order["amount"])*double.parse(user.order["price"])); 
                      });
                    },
                  ),
                ),
                SizedBox(height: 5),
                
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Total(${widget.currency1})",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.22,
                  alignment: Alignment.centerRight,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                  ),
                  child: Text("${Decimal.parse(total.toString())}", style: TextStyle(fontSize: 12)),
                ),
                SizedBox(width: 20,)
              ],
            ),
            RaisedButton(
              onPressed: () {
                
                String id1 = user.accounts[user.coins[widget.currency1]]["id"];
                String id2 = user.accounts[user.coins[widget.currency2]]["id"];
                
                api
                    .trade(id1, id2, user.order["price"], user.order["amount"], widget.currency1 + "/" + widget.currency2,
                        decisionText.toUpperCase())
                    .then((value) {
                      amountController.clear();
                      pic.controller.clear();
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.all(0.0),
              child: decisionText == "buy" ? DecisionButton(decision: decisionText, currency: widget.currency1) : DecisionButton(decision: decisionText, currency: widget.currency1),
            ),
            
          ],
        ),
      ),
    );
  }
}

class CurrencyTextInputFormatter extends TextInputFormatter{
  final double maxInputValue;

  CurrencyTextInputFormatter({required this.maxInputValue});
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d*');
    String newString = regEx.stringMatch(newValue.text) ?? '';
    
    if(maxInputValue != null){
      if(double.tryParse(newValue.text) == null){
        return TextEditingValue(
          text: newString,
          selection: newValue.selection,
        );
      }
      if(double.tryParse(newValue.text)! > maxInputValue){
        newString = maxInputValue.toString();
      }
    }
    return TextEditingValue(
      text: newString,
      selection: newValue.selection
    );
  }

}