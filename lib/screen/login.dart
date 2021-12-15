import 'package:canarioswap/components/rounded_button.dart';
import 'package:canarioswap/components/rounded_input.dart';
import 'package:canarioswap/components/rounded_password_input.dart';
import 'package:canarioswap/screen/trade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'user/user.dart';

class Login extends StatefulWidget {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 270);
  String username = " ";
  String password = " ";
  String email = " ";
  UserTemp u = UserTemp();
  bool _passwordVisible = false;
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference wallets =
      FirebaseFirestore.instance.collection('wallets');

  // late Widget forms = options();

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
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: shader(
      //     "Canario",
      //     TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Stack(
        children: [
          // Cancel Button
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration,
            child: isLogin ? Container() : Align(
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
                                print('Wrong password provided for that user.');
                              }
                            }
                          },
                          email: email,
                          password: password),
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
              if(viewInset == 0 && isLogin){
                return buildRegisterContainer();
              } else if(!isLogin){
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
                      
                        SizedBox(height: 40),
                        RoundedInput(icon: Icons.mail, hint: "Email"),
                        RoundedPasswordInput(hint: "Password"),
                        RoundedPasswordInput(hint: "Repeat password"),
                        SizedBox(height: 10),
                        RoundedButton(
                        title: "SIGN UP",
                        onTap: () {
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
                              print('Wrong password provided for that user.');
                            }
                          }
                        },
                        email: email,
                        password: password),
                      ]),
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
          onTap: !isLogin ? null : () {
            animationController.forward();
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: isLogin ? Text(
              "Dont't have an account? Sign up",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ) 
            
          ) : Container(),
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

  // Widget login() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Center(
  //         child: Container(
  //           margin: EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey,
  //                 blurRadius: 5.0,
  //                 spreadRadius: 0.0,
  //                 offset: Offset(5.0, 5.0), // shadow direction: bottom right
  //               )
  //             ],
  //           ),
  //           child: Container(
  //             height: 400,
  //             width: 500,
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 shader("Wellcome to Canario", TextStyle(fontSize: 24)),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text("Email",
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                     SizedBox(height: 5),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           height: 50,
  //                           width: 410,
  //                           child: TextField(
  //                             textAlign: TextAlign.center,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 email = value.trim();
  //                               });
  //                             },
  //                             decoration: const InputDecoration(
  //                               border: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Colors.yellow),
  //                               ),
  //                               hintText: 'Email',
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 30,
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 30,
  //                     ),
  //                     Text("Password",
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                     SizedBox(height: 5),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           height: 50,
  //                           width: 410,
  //                           child: TextField(
  //                             textAlign: TextAlign.center,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 password = value.trim();
  //                               });
  //                             },
  //                             obscureText: !_passwordVisible,
  //                             decoration: const InputDecoration(
  //                               border: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Colors.green),
  //                               ),
  //                               hintText: 'Password',
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: 10),
  //                         GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               _passwordVisible = !_passwordVisible;
  //                             });
  //                           },
  //                           child: Icon(
  //                             _passwordVisible
  //                                 ? Icons.visibility
  //                                 : Icons.visibility_off,
  //                             color: Theme.of(context).primaryColorDark,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: 40),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         Container(
  //                           height: 40.0,
  //                           child: RaisedButton(
  //                             onPressed: () {
  //                               setState(() {
  //                                 forms = options();
  //                               });
  //                             },
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0)),
  //                             padding: EdgeInsets.all(0.0),
  //                             child: Ink(
  //                               decoration: BoxDecoration(
  //                                   gradient: LinearGradient(
  //                                     begin: Alignment.topRight,
  //                                     end: Alignment.bottomLeft,
  //                                     colors: [
  //                                       Colors.yellow,
  //                                       Colors.green,
  //                                     ],
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(30.0)),
  //                               child: Container(
  //                                 constraints: BoxConstraints(
  //                                     maxWidth: 100.0, minHeight: 20.0),
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   "Back",
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           height: 40.0,
  //                           child: RaisedButton(
  //                             onPressed: () {
  //                               try {
  //                                 FirebaseAuth.instance
  //                                     .signInWithEmailAndPassword(
  //                                         email: email, password: password)
  //                                     .then((value) {
  //                                   UserCredential userCredential = value;
  //                                   Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => Trade()),
  //                                   );

  //                                 });
  //                               } on FirebaseAuthException catch (e) {
  //                                 if (e.code == 'user-not-found') {
  //                                   print('No user found for that email.');
  //                                 } else if (e.code == 'wrong-password') {
  //                                   print(
  //                                       'Wrong password provided for that user.');
  //                                 }
  //                               }
  //                             },
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0)),
  //                             padding: EdgeInsets.all(0.0),
  //                             child: Ink(
  //                               decoration: BoxDecoration(
  //                                   gradient: LinearGradient(
  //                                     begin: Alignment.topRight,
  //                                     end: Alignment.bottomLeft,
  //                                     colors: [
  //                                       Colors.yellow,
  //                                       Colors.green,
  //                                     ],
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(30.0)),
  //                               child: Container(
  //                                 constraints: BoxConstraints(
  //                                     maxWidth: 100.0, minHeight: 20.0),
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   "Login",
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget options() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Center(
  //         child: Container(
  //           margin: EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey,
  //                 blurRadius: 5.0,
  //                 spreadRadius: 0.0,
  //                 offset: Offset(5.0, 5.0), // shadow direction: bottom right
  //               )
  //             ],
  //           ),
  //           child: Container(
  //             height: 400,
  //             width: 500,
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 shader("Wellcome to Canario", TextStyle(fontSize: 24)),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     SizedBox(
  //                       height: 40,
  //                     ),
  //                     Container(
  //                       height: 50.0,
  //                       width: 150,
  //                       child: RaisedButton(
  //                         onPressed: () {
  //                           setState(() {
  //                             forms = createAccount();
  //                           });
  //                         },
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20.0)),
  //                         padding: EdgeInsets.all(0.0),
  //                         child: Ink(
  //                           decoration: BoxDecoration(
  //                               gradient: LinearGradient(
  //                                 begin: Alignment.topRight,
  //                                 end: Alignment.bottomLeft,
  //                                 colors: [
  //                                   Colors.yellow,
  //                                   Colors.green,
  //                                 ],
  //                               ),
  //                               borderRadius: BorderRadius.circular(30.0)),
  //                           child: Container(
  //                             constraints: BoxConstraints(
  //                                 maxWidth: 150.0, minHeight: 20.0),
  //                             alignment: Alignment.center,
  //                             child: Text(
  //                               "Create Account",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 20,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     Container(
  //                       height: 50.0,
  //                       width: 80,
  //                       child: RaisedButton(
  //                         onPressed: () {
  //                           setState(() {
  //                             forms = login();
  //                           });
  //                         },
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20.0)),
  //                         padding: EdgeInsets.all(0.0),
  //                         child: Ink(
  //                           decoration: BoxDecoration(
  //                               gradient: LinearGradient(
  //                                 begin: Alignment.topRight,
  //                                 end: Alignment.bottomLeft,
  //                                 colors: [
  //                                   Colors.yellow,
  //                                   Colors.green,
  //                                 ],
  //                               ),
  //                               borderRadius: BorderRadius.circular(30.0)),
  //                           child: Container(
  //                             constraints: BoxConstraints(
  //                                 maxWidth: 100.0, minHeight: 20.0),
  //                             alignment: Alignment.center,
  //                             child: Text(
  //                               "Login",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 20,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget createAccount() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Center(
  //         child: Container(
  //           margin: EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey,
  //                 blurRadius: 5.0,
  //                 spreadRadius: 0.0,
  //                 offset: Offset(5.0, 5.0), // shadow direction: bottom right
  //               )
  //             ],
  //           ),
  //           child: Container(
  //             height: 400,
  //             width: 500,
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 shader("Wellcome to Canario", TextStyle(fontSize: 24)),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text("Email",
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                     SizedBox(height: 5),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           height: 50,
  //                           width: 410,
  //                           child: TextField(
  //                             textAlign: TextAlign.center,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 email = value.trim();
  //                               });
  //                             },
  //                             decoration: const InputDecoration(
  //                               border: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Colors.yellow),
  //                               ),
  //                               hintText: 'Email',
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 30,
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 30,
  //                     ),
  //                     Text("Password",
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                     SizedBox(height: 5),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           height: 50,
  //                           width: 410,
  //                           child: TextField(
  //                             textAlign: TextAlign.center,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 password = value.trim();
  //                               });
  //                             },
  //                             obscureText: !widget._passwordVisible1,
  //                             decoration: const InputDecoration(
  //                               border: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Colors.green),
  //                               ),
  //                               hintText: 'Password',
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: 10),
  //                         GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               widget._passwordVisible1 =
  //                                   !widget._passwordVisible1;
  //                             });
  //                           },
  //                           child: Icon(
  //                             widget._passwordVisible1
  //                                 ? Icons.visibility
  //                                 : Icons.visibility_off,
  //                             color: Theme.of(context).primaryColorDark,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: 40),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         Container(
  //                           height: 40.0,
  //                           child: RaisedButton(
  //                             onPressed: () {
  //                               setState(() {
  //                                 forms = options();
  //                               });
  //                             },
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0)),
  //                             padding: EdgeInsets.all(0.0),
  //                             child: Ink(
  //                               decoration: BoxDecoration(
  //                                   gradient: LinearGradient(
  //                                     begin: Alignment.topRight,
  //                                     end: Alignment.bottomLeft,
  //                                     colors: [
  //                                       Colors.yellow,
  //                                       Colors.green,
  //                                     ],
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(30.0)),
  //                               child: Container(
  //                                 constraints: BoxConstraints(
  //                                     maxWidth: 100.0, minHeight: 20.0),
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   "Back",
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           height: 40.0,
  //                           child: RaisedButton(
  //                             onPressed: () {
  //                               try {
  //                                 FirebaseAuth.instance
  //                                     .createUserWithEmailAndPassword(
  //                                         email: email, password: password)
  //                                     .then((value) {
  //                                   UserCredential userCredential = value;
  //                                   var e = FirebaseAuth
  //                                       .instance.currentUser!.email!;
  //                                   u.setExternalId(email);
  //                                   u.setNewUser().then((_) {
  //                                     wallets.add({
  //                                       "$e": {
  //                                         "secretAlgo":
  //                                             u.wallets["ALGO"]!["secret"]!,
  //                                         "addressAlgo":
  //                                             u.wallets["ALGO"]!["address"]!,
  //                                         "mnemonicEth":
  //                                             u.wallets["ETH"]!["mnemonic"]!,
  //                                         "xpubEth": u.wallets["ETH"]!["xpub"]!,
  //                                         "customerId": u.customerId,
  //                                       }
  //                                     }).then((_) {

  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                             builder: (context) => Trade()),
  //                                       );
  //                                     });
  //                                   });
  //                                 });
  //                               } on FirebaseAuthException catch (e) {
  //                                 if (e.code == 'weak-password') {
  //                                   print('The password provided is too weak.');
  //                                 } else if (e.code == 'email-already-in-use') {
  //                                   print(
  //                                       'The account already exists for that email.');
  //                                 }
  //                               } catch (e) {
  //                                 print(e);
  //                               }
  //                             },
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0)),
  //                             padding: EdgeInsets.all(0.0),
  //                             child: Ink(
  //                               decoration: BoxDecoration(
  //                                   gradient: LinearGradient(
  //                                     begin: Alignment.topRight,
  //                                     end: Alignment.bottomLeft,
  //                                     colors: [
  //                                       Colors.yellow,
  //                                       Colors.green,
  //                                     ],
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(30.0)),
  //                               child: Container(
  //                                 constraints: BoxConstraints(
  //                                     maxWidth: 100.0, minHeight: 20.0),
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   "Create",
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

}
