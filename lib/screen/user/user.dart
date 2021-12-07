import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'dart:convert';
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';

import 'package:canarioswap/tatum/tatum_api.dart';

class User {
  User._privateConstructor();
  static final User _user = User._privateConstructor();
  String mnemonic = " ";
  String externalId = " ";
  List<Map> accounts = [];
  Tatum api = Tatum();
  Map<String, Map<String, dynamic>> wallets = {};

  factory User() {
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

  void setExternalId(String _username, _password) async {
    List<int> bytes = utf8.encode(_username + _password);
    externalId = sha256.convert(bytes).toString();
    var acc = await api.accountsWithBalances(externalId);

    // ignore: unnecessary_null_comparison
    if (false) {
      // this information need to be taken from firebase

      wallets["ALGO"] = await api.generateWallet();
      wallets["ETH"] = await api.generateEtherWallet();
    } else {
      wallets["ALGO"] = await api.generateWallet();
      accounts.add(await api.generateUserAccount(
          externalId, wallets["ALGO"]!["address"], "ALGO"));

      wallets["ETH"] = await api.generateEtherWallet();

      accounts.add(await api.generateEtherUserAccount(
          externalId, wallets["ETH"]!["xpub"], "ETH"));

      var balance = await api.getBalance(wallets["ALGO"]!["address"]);
      print(balance);
    }
  }

  void withdraw(String coin, to, amount) async {
    if (coin == "eth") {
      await api.sendEther(to, amount, wallets["ETH"]!["secret"]);
    } else {
      await api.sendAlgo(wallets["ALGO"]!["address"]!, to, "1", amount,
          "canario withdraw", wallets["ALGO"]!["secret"]);
    }
  }

  Future<int> balance(String coin) async {
    int value;
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
