// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
