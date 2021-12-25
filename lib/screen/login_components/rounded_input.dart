import 'package:canarioswap/screen/user/user.dart';
import 'package:flutter/material.dart';

import 'input_container.dart';

class RoundedInput extends StatefulWidget {
  RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  UserTemp user = UserTemp();

  @override
  _RoundedInputState createState() => _RoundedInputState();
}

class _RoundedInputState extends State<RoundedInput> {
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        cursorColor: Colors.green,
        decoration: InputDecoration(
          icon: Icon(widget.icon, color: Colors.green),
          hintText: widget.hint,
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            widget.user.email = value.trim();
          });
        },
      ),
    );
  }
}
