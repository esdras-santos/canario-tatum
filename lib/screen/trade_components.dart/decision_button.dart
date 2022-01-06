// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';

class DecisionButton extends StatefulWidget {
  final String decision; 
  final String currency;
  const DecisionButton({ Key? key, required this.decision, required this.currency }) : super(key: key);

  @override
  _DecisionButtonState createState() => _DecisionButtonState();
}

class _DecisionButtonState extends State<DecisionButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 55.0,
      width: size.width * 0.2,
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: widget.decision == "buy"
                  ? [
                      Colors.greenAccent,
                      Colors.green,
                    ]
                  : [
                      Colors.redAccent,
                      Colors.red,
                    ],
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints:
              BoxConstraints(maxWidth: size.width * 0.4, minHeight: 20.0),
          alignment: Alignment.center,
          child: Text(
            widget.decision+" "+widget.currency,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}