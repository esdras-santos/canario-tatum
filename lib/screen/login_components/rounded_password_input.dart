import 'package:canarioswap/screen/user/user.dart';
import 'package:flutter/material.dart';

import 'input_container.dart';

class RoundedPasswordInput extends StatefulWidget {
  RoundedPasswordInput({
    required this.hint,
    Key? key,
  }) : super(key: key);

  final String hint;
  UserTemp user = UserTemp();

  @override
  State<StatefulWidget> createState() => _RoundedPasswordInputState();
}

class _RoundedPasswordInputState extends State<RoundedPasswordInput> {
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        obscureText: true,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.green),
          hintText: widget.hint,
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            if (widget.hint == "Password") {
              widget.user.pass = value.trim();
            } else {
              widget.user.rpass = value.trim();
            }
              
          });
        },
      ),
    );
  }
}
