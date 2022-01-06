// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:canarioswap/screen/user/user.dart';
import 'package:canarioswap/tatum/tatum_api.dart';

import 'package:flutter/material.dart';
import 'dart:io';

class MyOrders extends StatefulWidget {
  List<Text> myOrdersPrice;
  List<Text> myOrdersAmount;
  List<Text> myPairs;
  List<Text> myOrdersTypes;
  List<Text> myOrdersTotal;
  List<String> ids;
  List<Widget> deleteButton;

  MyOrders({ Key? key, required this.myOrdersPrice, required this.myOrdersAmount, required this.myPairs,
   required this.myOrdersTypes, required this.myOrdersTotal, required this.ids, required this.deleteButton}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  UserTemp user = UserTemp();
  
  Tatum api = Tatum();

  @override
  void initState(){
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          const BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(5.0, 5.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Container(
        height: 130,
        width: 630,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(
                children: widget.myPairs,
              ),
              Column(
                children: widget.myOrdersTypes,
              ),
              Column(
                children: widget.myOrdersPrice,
              ),
              Column(
                children: widget.myOrdersAmount,
              ),
              Column(
                children: widget.myOrdersTotal,
              ),
              Column(
                children: widget.deleteButton,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
