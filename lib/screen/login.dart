// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:canarioswap/screen/login_components/rounded_button.dart';
import 'package:canarioswap/screen/login_components/rounded_input.dart';
import 'package:canarioswap/screen/login_components/rounded_password_input.dart';
import 'package:canarioswap/screen/trade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'user/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 270);
  UserTemp u = UserTemp();
  bool _passwordVisible = false;
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference wallets =
    FirebaseFirestore.instance.collection('wallets');


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Stack(
        children: [
          // Cancel Button
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration,
            child: isLogin
                ? Container()
                : Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.1,
                      alignment: Alignment.bottomCenter,
                      child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            animationController.reverse();
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          color: Colors.black),
                    ),
                  ),
          ),
          // Login Form
          AnimatedOpacity(
            opacity: isLogin ? 1.0 : 0.0,
            duration: animationDuration * 4,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultLoginSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      shader(
                        "Welcome back to Canario",
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(height: 40),
                      RoundedInput(icon: Icons.mail, hint: "Email"),
                      RoundedPasswordInput(hint: "Password"),
                      SizedBox(height: 10),
                      RoundedButton(
                          title: "LOGIN",
                          onTap: () {
                            try {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: u.email, password: u.pass)
                                  .then((value) {
                                    
                                UserCredential userCredential = value;
                                String useremail = auth.currentUser!.email!;
                                u.setExternalId(useremail);
                                wallets.where(useremail).get().then((value) {
                                  var json = convert.jsonEncode(value.docs.asMap()[0]!.data());
                                  var wallet = convert.jsonDecode(json) as Map;
                                  u.initWallet(
                                    wallet[useremail]["secretAlgo"],
                                    wallet[useremail]["addressAlgo"],
                                    wallet[useremail]["mnemonicEth"],
                                    wallet[useremail]["xpubEth"],
                                    wallet[useremail]["customerId"]).then((_){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Trade()),
                                      );
                                    });
                                });
                                
                              });
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          },
                          email: u.email,
                          password: u.pass),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Register Container
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }
              return Container();
            },
          ),
          // Register Form
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration * 5,
            child: Visibility(
              visible: !isLogin,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    height: defaultLoginSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Welcome to Canario",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black)),
                        SizedBox(height: 40),
                        RoundedInput(icon: Icons.mail, hint: "Email"),
                        RoundedPasswordInput(hint: "Password"),
                        RoundedPasswordInput(hint: "Repeat password"),
                        SizedBox(height: 10),
                        RoundedButton(
                            title: "SIGN UP",
                            onTap: () {
                              if (u.pass == u.rpass) {
                                try {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: u.email, password: u.pass)
                                      .then((value) {
                                    UserCredential userCredential = value;
                                    var e = FirebaseAuth
                                        .instance.currentUser!.email!;
                                    u.setExternalId(u.email);
                                    u.setNewUser().then((_) {
                                      wallets.add({
                                        "$e": {
                                          "secretAlgo":
                                              u.wallets["ALGO"]!["secret"]!,
                                          "addressAlgo":
                                              u.wallets["ALGO"]!["address"]!,
                                          "mnemonicEth":
                                              u.wallets["ETH"]!["mnemonic"]!,
                                          "xpubEth":
                                              u.wallets["ETH"]!["xpub"]!,
                                          "customerId": u.customerId,
                                        }
                                      }).then((_) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Trade()),
                                        );
                                      });
                                    });
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    print(
                                        'The password provided is too weak.');
                                  } else if (e.code ==
                                      'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                print("wrong password");
                              }
                            },
                            email: u.email,
                            password: u.pass,
                          ),
                        ],
                      ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRegisterContainer() {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width * 0.8,
        height: containerSize.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100), topRight: Radius.circular(100)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.green,
              Colors.yellow,
              Colors.green,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? Text("Dont't have an account? Sign up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ))
              : Container(),
        ),
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
          Colors.green,
          Colors.yellow,
          Colors.green,
        ],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style),
    );
  }

 
}
