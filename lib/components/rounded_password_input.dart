import 'package:flutter/material.dart';

import 'input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    required this.hint,
    Key? key,
  }) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        obscureText: true,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.green),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
