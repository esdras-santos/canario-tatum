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
  Map accTest = {};
  Tatum api = Tatum();
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

  Future<void> setNewUser(String _username, _password) async {
    List<int> bytes = utf8.encode(_username + _password);
    externalId = sha256.convert(bytes).toString();

    wallets["ALGO"] = await api.generateWallet();
    accounts.add(await api.generateUserAccount(
        externalId, wallets["ALGO"]!["address"], "ALGO"));

    wallets["ETH"] = await api.generateEtherWallet();

    accounts.add(await api.generateEtherUserAccount(
        externalId, wallets["ETH"]!["xpub"], "ETH"));

    var balance = await api.getBalance(wallets["ALGO"]!["address"]);
  }

  Future<void> initWallet(String secret, address, mnemonic, xpub) async {
    wallets["ALGO"]!["secret"] = secret;
    wallets["ALGO"]!["address"] = address;
    wallets["ETH"]!["mnemonic"] = mnemonic;
    wallets["ETH"]!["xpub"] = xpub;
    accounts.add(await api.generateUserAccount(
        externalId, wallets["ALGO"]!["address"], "ALGO"));
    print(accounts[0]["customerId"]);
    accounts.add(await api.generateEtherUserAccount(
        externalId, wallets["ETH"]!["xpub"], "ETH"));
    print(accounts[1]["customerId"]);
  }

  void setExternalId(String _username, _password) {
    List<int> bytes = utf8.encode(_username + _password);
    externalId = sha256.convert(bytes).toString();
  }

  void withdraw(String coin, to, amount) async {
    if (coin == "eth") {
      await api.sendEther(to, amount, wallets["ETH"]!["secret"]);
    } else {
      await api.sendAlgo(wallets["ALGO"]!["address"]!, to, "1", amount,
          "canario withdraw", wallets["ALGO"]!["secret"]);
    }
  }

  Future<num> balance(String coin) async {
    num value;
    if (coin == "eth") {
      var ethAddress =
          await api.generateEtherAddress(wallets["ETH"]!["xpub"]!, "0");
      value = await api.getEtherBalance(ethAddress["address"]);
      return value;
    } else {
      value = await api.getBalance(wallets["ALGO"]!["address"]!);
      return value;
    }
  }

  Future<String> etherAddress() async {
    var ethAddress =
        await api.generateEtherAddress(wallets["ETH"]!["xpub"]!, "0");
    return ethAddress["address"];
  }

  String getExternalId() {
    return externalId;
  }
}
