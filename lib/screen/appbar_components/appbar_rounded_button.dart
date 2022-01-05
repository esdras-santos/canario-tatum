import 'package:flutter/material.dart';

class AppbarRoundedButton extends StatelessWidget {
  const AppbarRoundedButton({
    Key? key,
    required this.title,
    required this.onTap
  }) : super(key: key);

  final String title;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RaisedButton(
      elevation: 0.0,
      onPressed: onTap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      padding: EdgeInsets.only(top: 10.0, bottom: 10),
      child: Container(
        height: 45.0,
        width: size.width * 0.1,
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                        Colors.green,
                        Colors.yellow,
                        Colors.green,
                      ]
              ),
          borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints:
                BoxConstraints(maxWidth: size.width * 0.4, minHeight: 10.0, maxHeight: 20),
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
