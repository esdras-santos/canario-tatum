import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:isolate';

import 'login.dart';
import 'trade.dart';
import 'user/user.dart';

class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  var address = " ";
  var amount = " ";
  List<Widget> assetList = [];
  UserTemp user = UserTemp();
  var etherBalance = " ";
  var algoBalance = " ";
  var ethadd = " ";
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // this asset list need to be populated with the api data
    user.balance("eth").then((value) {
      setState(() {
        etherBalance = "$value";
      });
      return user.balance("algo");
    }).then((value) {
      setState(() {
        algoBalance = "$value";
      });
      return user.etherAddress();
    }).then((value) {
      setState(() {
        ethadd = value;
      });
    });
    updateBalances();
  }

  //update the balances in each 3 seonds
  Future updateBalances() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      var value = await user.getAccounts(user.accounts[0]["customerId"]);
      
      setState(() {
        algoBalance = value[0]["balance"]["availableBalance"];
        etherBalance = value[1]["balance"]["availableBalance"];
      });
    }
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

  Future<Widget> withdraw(String coin) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Withdraw",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("withdraw Amount", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Container(
                      height: 50,
                      width: 450,
                      child: TextField(
                        onChanged: (value) {
                          amount = value;
                        },
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                          hintText: 'Amount',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("to the Address", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Container(
                      height: 50,
                      width: 450,
                      child: TextField(
                        onChanged: (value) {
                          address = value;
                        },
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          hintText: 'Address',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[600],
                ),
                onPressed: () {
                  if (coin == "ETH") {
                    //calculate fee
                    user.getFee(ethadd, address, amount).then((value) {
                      user
                          .withdraw(
                              user.accounts[1]["id"], address, amount, value)
                          .then((_) => Navigator.pop(context));
                    });
                  } else {
                    user
                        .withdraw(
                            user.accounts[0]["id"], address, amount, "0.001")
                        .then((_) => Navigator.pop(context));
                  }
                },
                child: Text(
                  "withdraw",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  Future<Widget> deposit(String address) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Deposit Address",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: address));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Deposit address copied to clipboard"),
                              ),
                            );
                          },
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey)),
                            child: Text(
                              " " + address + " ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: address));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Deposit address copied to clipboard"),
                                ),
                              );
                            },
                            child: Icon(Icons.copy))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green[600]),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  Widget assetsCard(
      String iconPath, String symbol, String address) {
    return Card(
      elevation: 8.0,
      child: Container(
        width: 700.0,
        height: 100.0,
        child: Row(
          children: <Widget>[
            SizedBox(width: 40),
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(iconPath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: 19.0,
            ),
            Material(
              child: Text(
                symbol,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(width: 40),
            Text("balance: ", style: TextStyle(fontSize: 16)),
            Material(
              child: Text(
                symbol == "ETH" ? etherBalance : algoBalance,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
            SizedBox(width: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green[600]),
              onPressed: () {
                deposit(address);
              },
              child: Text(
                "Deposit",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.yellow[600]),
              onPressed: () {
                withdraw(symbol);
              },
              child: Text(
                "Withdraw",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: shader(
            "Canario",
            TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("LogOut"),
                                Icon(
                                  Icons.logout,
                                  color: Colors.green,
                                )
                              ]),
                          onTap: () {
                            auth.signOut()
                            .then((_) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                                ));
                          },
                        ),
                      ],
                  child: Icon(Icons.menu, color: Colors.green))),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20, top: 5, bottom: 5),
              child: Container(
                height: 40,
                width: 80,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    height: 45,
                    width: 85,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.yellow,
                            Colors.green,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Container(
                      width: 80,
                      height: 20,
                      constraints: BoxConstraints(
                          maxWidth: 80.0, minHeight: 10.0, maxHeight: 20),
                      alignment: Alignment.center,
                      child: Text(
                        "Trade",
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
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, top: 5, bottom: 5),
              child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
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
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 100.0, minHeight: 20.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Wallet",
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
            )
          ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                assetsCard('images/algologo.png', 'ALGO',
                    user.wallets["ALGO"]!["address"]!),
                assetsCard('images/ethlogo.png', 'ETH',
                    ethadd)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
