import 'package:canarioswap/screen/trade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';

import 'user/user.dart';

class Login extends StatefulWidget {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = " ";
  String password = " ";
  String email = " ";
  UserTemp u = UserTemp();
  bool _passwordVisible = false;
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference wallets =
      FirebaseFirestore.instance.collection('wallets');

  late Widget forms = options();

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
        body: forms);
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

  Widget login() {
    return Column(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Email",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 410,
                            child: TextField(
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  email = value.trim();
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow),
                                ),
                                hintText: 'Email',
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 410,
                            child: TextField(
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  password = value.trim();
                                });
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
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 40.0,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  forms = options();
                                });
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
                                  constraints: BoxConstraints(
                                      maxWidth: 100.0, minHeight: 20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Back",
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
                          Container(
                            height: 40.0,
                            child: RaisedButton(
                              onPressed: () {
                                try {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: password)
                                      .then((value) {
                                    UserCredential userCredential = value;
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Trade()),
                                    );
                                    

                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    print(
                                        'Wrong password provided for that user.');
                                  }
                                }
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
                                  constraints: BoxConstraints(
                                      maxWidth: 100.0, minHeight: 20.0),
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget options() {
    return Column(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 50.0,
                        width: 150,
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              forms = createAccount();
                            });
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
                              constraints: BoxConstraints(
                                  maxWidth: 150.0, minHeight: 20.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Create Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50.0,
                        width: 80,
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              forms = login();
                            });
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
                              constraints: BoxConstraints(
                                  maxWidth: 100.0, minHeight: 20.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget createAccount() {
    return Column(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Email",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 410,
                            child: TextField(
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  email = value.trim();
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow),
                                ),
                                hintText: 'Email',
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 410,
                            child: TextField(
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  password = value.trim();
                                });
                              },
                              obscureText: !widget._passwordVisible1,
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
                                widget._passwordVisible1 =
                                    !widget._passwordVisible1;
                              });
                            },
                            child: Icon(
                              widget._passwordVisible1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 40.0,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  forms = options();
                                });
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
                                  constraints: BoxConstraints(
                                      maxWidth: 100.0, minHeight: 20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Back",
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
                          Container(
                            height: 40.0,
                            child: RaisedButton(
                              onPressed: () {
                                try {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password)
                                      .then((value) {
                                    UserCredential userCredential = value;
                                    var e = FirebaseAuth
                                        .instance.currentUser!.email!;
                                    u.setExternalId(email);
                                    u.setNewUser().then((_) {
                                      wallets.add({
                                        "$e": {
                                          "secretAlgo":
                                              u.wallets["ALGO"]!["secret"]!,
                                          "addressAlgo":
                                              u.wallets["ALGO"]!["address"]!,
                                          "mnemonicEth":
                                              u.wallets["ETH"]!["mnemonic"]!,
                                          "xpubEth": u.wallets["ETH"]!["xpub"]!,
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
                                    print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  print(e);
                                }
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
                                  constraints: BoxConstraints(
                                      maxWidth: 100.0, minHeight: 20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Create",
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget createAccount2() {
  //   String tempass = " ";
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text("Password",
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //       SizedBox(height: 5),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Container(
  //             height: 50,
  //             width: 410,
  //             child: TextField(
  //               onChanged: (value) {
  //                 setState(() {
  //                   tempass = value;
  //                 });
  //               },
  //               obscureText: !widget._passwordVisible1,
  //               decoration: const InputDecoration(
  //                 border: OutlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.green),
  //                 ),
  //                 hintText: 'Password',
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 10),
  //           GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 widget._passwordVisible1 = !widget._passwordVisible1;
  //               });
  //             },
  //             child: Icon(
  //               widget._passwordVisible1
  //                   ? Icons.visibility
  //                   : Icons.visibility_off,
  //               color: Theme.of(context).primaryColorDark,
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         height: 30,
  //       ),
  //       Text("Repeat Password",
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //       SizedBox(height: 5),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Container(
  //             height: 50,
  //             width: 410,
  //             child: TextField(
  //               onChanged: (value) {
  //                 setState(() {
  //                   password = value;
  //                 });
  //               },
  //               obscureText: !widget._passwordVisible2,
  //               decoration: const InputDecoration(
  //                 border: OutlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.green),
  //                 ),
  //                 hintText: 'Password',
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 10),
  //           GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 widget._passwordVisible2 = !widget._passwordVisible2;
  //               });
  //             },
  //             child: Icon(
  //               widget._passwordVisible2
  //                   ? Icons.visibility
  //                   : Icons.visibility_off,
  //               color: Theme.of(context).primaryColorDark,
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 40),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           Container(
  //             height: 40.0,
  //             child: RaisedButton(
  //               onPressed: () {
  //                 setState(() {
  //                   forms = createAccount1();
  //                 });
  //               },
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20.0)),
  //               padding: EdgeInsets.all(0.0),
  //               child: Ink(
  //                 decoration: BoxDecoration(
  //                     gradient: LinearGradient(
  //                       begin: Alignment.topRight,
  //                       end: Alignment.bottomLeft,
  //                       colors: [
  //                         Colors.yellow,
  //                         Colors.green,
  //                       ],
  //                     ),
  //                     borderRadius: BorderRadius.circular(30.0)),
  //                 child: Container(
  //                   constraints:
  //                       BoxConstraints(maxWidth: 100.0, minHeight: 20.0),
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     "Back",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Container(
  //             height: 40.0,
  //             child: RaisedButton(
  //               onPressed: () {
  //                 FutureBuilder(
  //                   future: auth.createUserWithEmailAndPassword(
  //                       email: email, password: password),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasError) {
  //                       print(
  //                           "\n\ncreate account error: ${snapshot.error}\n\n");
  //                     }
  //                     if (snapshot.connectionState == ConnectionState.done) {
  //                       u.setExternalId(email, password);
  //                       return Trade();
  //                     }
  //                     return CircularProgressIndicator();
  //                   },
  //                 );
  //               },
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20.0)),
  //               padding: EdgeInsets.all(0.0),
  //               child: Ink(
  //                 decoration: BoxDecoration(
  //                     gradient: LinearGradient(
  //                       begin: Alignment.topRight,
  //                       end: Alignment.bottomLeft,
  //                       colors: [
  //                         Colors.yellow,
  //                         Colors.green,
  //                       ],
  //                     ),
  //                     borderRadius: BorderRadius.circular(30.0)),
  //                 child: Container(
  //                   constraints:
  //                       BoxConstraints(maxWidth: 100.0, minHeight: 20.0),
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     "Create",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
