// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:canarioswap/tatum/tatum_api.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'dart:io';

class OrdersForm extends StatefulWidget {
  List<Text> buyOrdersPrice;
  List<Text> buyOrdersAmount;
  List<Text> totalBuyOrdesAmount;
  List<Text> sellOrdersPrice;
  List<Text> sellOrdersAmount;
  List<Text> totalSellOrdersAmount;
  List<String> ids;
  String lastPrice;
  TextStyle lastPriceStyle; 
  OrdersForm({ Key? key, required this.buyOrdersPrice, 
    required this.buyOrdersAmount, required this.totalBuyOrdesAmount, required this.sellOrdersPrice, 
    required this.sellOrdersAmount, required this.totalSellOrdersAmount, required this.ids, required this.lastPrice, required this.lastPriceStyle}) : super(key: key);
  
  @override
  _OrdersFormState createState() => _OrdersFormState();
}

class _OrdersFormState extends State<OrdersForm> {

  @override
  void initState(){
    super.initState();
  }
  Tatum api = Tatum();

  
  

  @override
  Widget build(BuildContext context) {
    return Container(
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
          height: 380,
          width: 300,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              
              Container(
                height: 165,
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: widget.buyOrdersPrice,
                    ),
                    Column(
                      children: widget.buyOrdersAmount,
                    ),
                    Column(
                      children: widget.totalBuyOrdesAmount,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 20,
                      
                      child: Text(widget.lastPrice, style: widget.lastPriceStyle,),
                    ),
                  ),
                ],
              ),
              Container(
                height: 165,
                width: 300,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      widget.sellOrdersPrice.length > 0
                          ? Column(
                              children: widget.sellOrdersPrice,
                            )
                          : Container(),
                      widget.sellOrdersAmount.length > 0
                          ? Column(
                              children: widget.sellOrdersAmount,
                            )
                          : Container(),
                      widget.totalSellOrdersAmount.length > 0
                        ? Column(
                            children: widget.totalSellOrdersAmount,
                          )
                        : Container(),
                    ]),
              ),
            ],
          )),
    );
  }
}