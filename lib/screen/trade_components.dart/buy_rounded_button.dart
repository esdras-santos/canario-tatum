import 'package:flutter/material.dart';

class BuyRoundedButton extends StatelessWidget {
  const BuyRoundedButton({
    Key? key,
    required this.on,
  }) : super(key: key);

  final bool on;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 55.0,
      width: size.width * 0.1,
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: on
                  ? [
                      Colors.greenAccent,
                      Colors.green,
                    ]
                  : [
                      Colors.grey,
                      Colors.blueGrey
                    ],
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints:
              BoxConstraints(maxWidth: size.width * 0.4, minHeight: 20.0),
          alignment: Alignment.center,
          child: Text(
            "BUY",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: on ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
