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
  Map<String, Map<String, dynamic>> wallets = {
    "ALGO": {"secret": " ", "address": " "},
    "ETH": {"mnemonic": " ", "xpub": " "},
  };

  factory UserTemp() {
    return _user;
  }

  // void setMnemonic(String _username, _password) {
  //   String seed = bip39.mnemonicToSeedHex(_username + _password);
  //   bip32.BIP32 node =
  //       bip32.BIP32.fromSeed(Uint8List.fromList(HEX.decode(seed)));
  //   mnemonic = bip39.entropyToMnemonic(HEX.encode(node.privateKey!));
  // }

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
    accounts.add(acclist[1]);
  }

  void setExternalId(String _username) {
    List<int> bytes = utf8.encode(_username);
    var len = bytes.length / 2;
    externalId = sha256.convert(bytes).toString().substring(0, len.toInt());
  }

  Future<void> withdraw(String accountId, address, amount, fee) async {
    await api.withdraw(accountId, address, amount, fee);
  }

  Future<String> getFee(String from, to, amount) async {
    var estimation = await api.estimateEtherFee(from, to, amount);
    return estimation["gasPrice"];
  }

  Future<String> balance(String coin) async {
    if (coin == "eth") {
      return accounts[1]["balance"]["availableBalance"];
    } else {
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
