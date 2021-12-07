import 'package:canarioswap/screen/trade.dart';

import 'package:flutter/material.dart';

import 'user/user.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = " ";
  String password = " ";
  User u = User();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: shader(
          "Canario",
          TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                    offset: Offset(5.0, 5.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Container(
                height: 400,
                width: 500,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    shader("Wellcome to Canario", TextStyle(fontSize: 24)),
                    SizedBox(
                      height: 50,
                    ),
                    login(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shader(String text, TextStyle style) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.yellow,
          Colors.green,
        ],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style),
    );
  }

  Widget login() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Username",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 410,
              child: TextField(
                onChanged: (value) {
                  username = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  hintText: 'Username',
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text("Password",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 410,
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: !_passwordVisible,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  hintText: 'Password',
                ),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              child: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
        Container(
          height: 40.0,
          child: RaisedButton(
            onPressed: () {
              u.setExternalId(username, password);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Trade()),
              );
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.yellow,
                      Colors.green,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Container(
                constraints: BoxConstraints(maxWidth: 100.0, minHeight: 20.0),
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
