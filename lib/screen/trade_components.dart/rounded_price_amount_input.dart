import 'package:canarioswap/screen/user/user.dart';
import 'package:flutter/material.dart';

import 'input_container.dart';

class RoundedPriceAmountInput extends StatefulWidget {
  RoundedPriceAmountInput({
    required this.hint,
    Key? key,
  }) : super(key: key);

  final String hint;
  UserTemp user = UserTemp();

  @override
  State<StatefulWidget> createState() => _RoundedPriceAmountInputState();
}

class _RoundedPriceAmountInputState extends State<RoundedPriceAmountInput> {
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        textAlign: TextAlign.right,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.green),
          hintText: widget.hint,
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            if (widget.hint == "Price") {
              widget.user.order["price"] = value.trim();
            } else {
              widget.user.order["amount"] = value.trim();
            }
              
          });
        },
      ),
    );
  }
}
