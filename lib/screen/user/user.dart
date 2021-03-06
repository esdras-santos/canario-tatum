// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'dart:convert';
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';

import 'package:crypto/crypto.dart';
import 'package:canarioswap/tatum/tatum_api.dart';

class UserTemp {
  UserTemp._privateConstructor();
  static final UserTemp _user = UserTemp._privateConstructor();
  String mnemonic = " ";
  String externalId = " ";
  List<Map> accounts = [];
  String customerId = " ";
  Tatum api = Tatum();
  String email = " ";
  String pass = " ";
  String rpass = " ";
  Map<String, Map<String, dynamic>> wallets = {
    "ALGO": {"secret": " ", "address": " "},
    "ETH": {"mnemonic": " ", "xpub": " "},
  };

  Map order = {
    "price" : "0.0",
    "amount" : "0.0",
  };

  Map coins = {
    "ALGO":{"decimals": 6, "index": 0}, 
    "ETH": {"decimals": 18, "index": 1},
    "BTC": {"decimals": 8, "index": 2}
  };

  factory UserTemp() {
    return _user;
  }

  

  String getMnemonic() {
    return mnemonic;
  }

  Future<void> setNewUser() async {
    wallets["ALGO"] = await api.generateWallet();
    accounts.add(await api.generateUserAccount(externalId, "ALGO"));
    customerId = accounts[0]["customerId"];
    await api.assignAddress(accounts[0]["id"], wallets["ALGO"]!["address"]);

    wallets["ETH"] = await api.generateEtherWallet();

    accounts.add(await api.generateEtherUserAccount(
        externalId, wallets["ETH"]!["xpub"], "ETH"));
  }

  Future<List> getAccounts(String id) async {
    return await api.accountsWithBalances(id);
  }

  Future<void> initWallet(
      String secret, address, mnemonic, xpub, customerid) async {
    wallets["ALGO"]!["secret"] = secret;
    wallets["ALGO"]!["address"] = address;
    wallets["ETH"]!["mnemonic"] = mnemonic;
    wallets["ETH"]!["xpub"] = xpub;
    var acclist = await api.accountsWithBalances(customerid);
    accounts.add(acclist[0]);
    print("\n\n\n"+accounts[0]["balance"]["availableBalance"]+"\n\n\n");
    accounts.add(acclist[1]);
  }

  void setExternalId(String _username) {
    List<int> bytes = utf8.encode(_username);
    var len = bytes.length / 2;
    externalId = sha256.convert(bytes).toString().substring(0, len.toInt());
  }

  Future<void> withdraw(String accountId, address, amount, fee) async {
    var wd = await api.withdraw(accountId, address, amount, fee);
    var tx = await api.getTransactionByReference(wd["reference"]);
    await api.completeWithdraw(tx["id"], tx["txId"]);
  }

  Future<String> getFee(String from, to, amount) async {
    var estimation = await api.estimateEtherFee(from, to, amount);
    return estimation["gasPrice"];
  }

  Future<String> balance(String coin) async {
    if (coin == "eth") {
      print(accounts[1]["balance"]["availableBalance"]);
      return accounts[1]["balance"]["availableBalance"];
    } else {
      print(accounts[0]["balance"]["availableBalance"]);
      return accounts[0]["balance"]["availableBalance"];
    }
  }

  Future<String> etherAddress() async {
    var ethAddress = await api.generateEtherDepositAddress(accounts[1]["id"]);
    return ethAddress["address"];
  }

  String getExternalId() {
    return externalId;
  }
}
