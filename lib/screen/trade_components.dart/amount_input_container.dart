import 'package:flutter/material.dart';
import 'package:canarioswap/screen/user/user.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';


class AmountInputContainer extends StatefulWidget {
  AmountInputContainer({
    Key? key, required this.coin, required this.currency1, required this.totalString
  }) : super(key: key);

  int coin;
  String currency1;
  String totalString;

  var controller = TextEditingController();
  
  final UserTemp user = UserTemp();

  @override
  State<StatefulWidget> createState() => _AmountInputContainerState();
}

class _AmountInputContainerState extends State<AmountInputContainer>{
  double total = 0.0;

  @override
  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        
        Column(
          children: [
            SizedBox(height: 20),
            
            
          ],
        )
      ],
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