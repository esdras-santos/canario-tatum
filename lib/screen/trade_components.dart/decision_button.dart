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