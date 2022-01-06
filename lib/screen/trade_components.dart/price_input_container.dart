// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:canarioswap/screen/user/user.dart';


class PriceInputContainer extends StatefulWidget {
  PriceInputContainer({
    Key? key,
  }) : super(key: key);
  
  var controller = TextEditingController();
  
  final UserTemp user = UserTemp();

  @override
  State<StatefulWidget> createState() => _PriceInputContainerState();
}

class _PriceInputContainerState extends State<PriceInputContainer>{
  double maxInput = 0;

  @override
  void initState(){
    super.initState(); 
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
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
            controller: widget.controller,
            // keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyTextInputFormatter(),
            ],
            cursorColor: Colors.green,
            decoration: InputDecoration(
              hintText: "Price",
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState((){
                widget.user.order["price"] = value.trim();
              });
            },
          ),
        ),
        SizedBox(width: 20,)
      ],
    );
  }

}

class CurrencyTextInputFormatter extends TextInputFormatter{


  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d*');
    String newString = regEx.stringMatch(newValue.text) ?? '';
    return newString == newValue.text ? newValue : oldValue;
  }

}
