// Copyright 2022 esdras-santos

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Tatum {
  final apikey = 'cb4f36d4-83f2-4c7f-9f24-e9fe60d470c9';
  Future<Map<String, dynamic>> generateWallet() async {
    var url = Uri.https("api-eu1.tatum.io", "v3/algorand/wallet");
    var response = await http.get(url, headers: {"x-api-key": apikey});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    return {};
  }

  Future<Map<String, dynamic>> generateEtherWallet() async {
    var url = Uri.https("api-eu1.tatum.io", "v3/ethereum/wallet");
    var response = await http.get(url,
        headers: {"x-testnet-type": "ethereum-rinkeby", "x-api-key": apikey});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      return jsonResponse;
    }
    return {};
  }

  Future<Map<String, dynamic>> generateEtherDepositAddress(String id) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/offchain/account/$id/address");
    var response = await http.post(url, headers: {"content-type": "application/json", "x-api-key": apikey});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      return jsonResponse;
    }
    return {};
  }

  Future<Map> generateEtherAddress(String xpub, index) async {
    var url =
        Uri.https("api-eu1.tatum.io", "/v3/ethereum/address/${xpub}/${index}");
    var response = await http
        .get(url, headers: {"x-testnet-type": "rinkeby", "x-api-key": apikey});

    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<num> getBalance(String address) async {
    var url =
        Uri.https("api-eu1.tatum.io", "v3/algorand/account/balance/${address}");

    var response = await http.get(url, headers: {"x-api-key": apikey});

    var jsonResponse = convert.jsonDecode(response.body) as num;

    return jsonResponse;
  }

  Future<int> getEtherBalance(String address) async {
    var url =
        Uri.https("api-eu1.tatum.io", "v3/ethereum/account/balance/$address");
    var response = await http.get(url,
        headers: {"x-testnet-type": "ethereum-rinkeby", "x-api-key": apikey});
    print("\n\n ${response.body}\n\n");

    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return int.parse(jsonResponse["balance"]);
  }

  Future<Map> sendAlgo(String from, to, fee, amount, note, fromPrivKey) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/algorand/transaction");

    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };

    final body = convert.jsonEncode({
      "from": from,
      "to": to,
      "fee": fee,
      "amount": amount,
      "note": note,
      "fromPrivateKey": fromPrivKey
    });

    var response = await http.post(url, body: body, headers: headers);
    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<Map> sendEther(String to, amount, fromPrivKey) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/ethreum/transaction");

    Map<String, String> headers = {
      "content-type": "application/json",
      "x-testnet-type": "ethereum-rinkeby",
      "x-api-key": apikey
    };

    final body = convert.jsonEncode({
      "data": "",
      "to": to,
      "currency": "ETH",
      "amount": amount,
      "fromPrivateKey": fromPrivKey
    });

    var response = await http.post(url, body: body, headers: headers);
    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<Map> generateServiceAccount(String externalId, currency) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/ledger/account");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode({
      "currency": currency,
      "accountingCurrency": "USD",
      "customer": {"externalId": externalId}
    });
    var response = await http.post(url, body: body, headers: headers);
    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<Map> generateUserAccount(String externalId, currency) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/ledger/account");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode({
      "currency": currency,
      "accountingCurrency": "USD",
      "customer": {"externalId": externalId}
    });
    var response = await http.post(url, body: body, headers: headers);
    print(response.body);
    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<Map> generateEtherUserAccount(
      String externalId, xpub, currency) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/ledger/account");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-testnet-type": "ethereum-rinkeby",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode({
      "currency": currency,
      "xpub": xpub,
      "accountingCurrency": "USD",
      "customer": {"externalId": externalId}
    });
    var response = await http.post(url, body: body, headers: headers);
    print(response.body);
    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<List<dynamic>> accountsWithBalances(String id) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/ledger/account/customer/$id",
        {"pageSize": "50", "count": "true"});
    var response = await http.get(url,
        headers: {"x-api-key": apikey, "Content-Type": "application/json"});

    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    return jsonResponse;
  }

  Future<Map> trade(
      String currency1Id, currency2Id, price, amount, pair, type) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/trade");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode({
      "type": type,
      "price": price,
      "amount": amount,
      "pair": pair,
      "currency1AccountId": currency1Id,
      "currency2AccountId": currency2Id,
    });
    var response = await http.post(url, body: body, headers: headers);
    print("\n\n ${response.body}\n\n");
    var jsonResponse = convert.jsonDecode(response.body) as Map;

    return jsonResponse;
  }

  Future<Map> withdraw(
      String said, addr, amount, fee) async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/offchain/withdrawal");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode({
      "senderAccountId": said,
      "address": addr,
      "amount": amount,
      "fee": fee,
    });
    var response = await http.post(url, body: body, headers: headers);
    print("\n\n ${response.body}\n\n");
    var jsonResponse = convert.jsonDecode(response.body) as Map;

    return jsonResponse;
  }

  Future<List> chart(String pair, from, to, timeFrame) async {
    var url = Uri.https("api-eu1.tatum.io", "v3/trade/chart");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode(
        {"pair": pair, "from": from, "to": to, "timeFrame": timeFrame});
    var response = await http.post(url, body: body, headers: headers);
    var jsonResponse = convert.jsonDecode(response.body) as List;
    return jsonResponse;
  }

  Future<List> openTrades(String type) async {
    var url =
        Uri.https("api-eu1.tatum.io", "/v3/trade/${type}", {"pageSize": "10"});
    var response = await http.get(url, headers: {"x-api-key": apikey});

    var jsonResponse = convert.jsonDecode(response.body) as List;
    return jsonResponse;
  }

  Future<List<Map>> allOpenTrades() async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/trade/");
    var response = await http.get(url, headers: {"x-api-key": apikey});

    var jsonResponse = convert.jsonDecode(response.body) as List<Map>;
    return jsonResponse;
  }

  Future<List> myOpenTrades(id, type) async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/trade/$type");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode({
      "customerId": id,
      "pageSize": 10,
    });
    var response = await http.post(url,body: body, headers: headers);
    
    var jsonResponse = convert.jsonDecode(response.body) as List;
    return jsonResponse;
  }

  Future<Map> assignAddress(String id, address) async {
    var url = Uri.https("api-eu1.tatum.io",
        "v3/offchain/account/$id/address/$address", {"index": "1"});
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-api-key": apikey
    };

    var response = await http.post(url, headers: headers);
    print("\n\n${response.body}\n\n");
    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<Map> estimateEtherFee(
      String from, to, amount) async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/ethereum/gas");
    Map<String, String> headers = {
      "content-type": "application/json",
      "x-testnet-type": "ethereum-ropsten",
      "x-api-key": apikey
    };
    final body = convert.jsonEncode({
      "from": from,
      "to": to,
      "amount": amount,
      
    });
    var response = await http.post(url, body: body, headers: headers);
    print("\n\n ${response.body}\n\n");
    var jsonResponse = convert.jsonDecode(response.body) as Map;

    return jsonResponse;
  }

  Future<Map> deleteTrade(tradeId) async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/trade/$tradeId");
    var response = await http.delete(url, headers: {"x-api-key": apikey});
    print(response.body);
    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<List> getWithdraw() async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/offchain/withdrawal", {"pageSize": "10"});
    var response = await http.get(url, headers: {"x-api-key": apikey});

    var jsonResponse = convert.jsonDecode(response.body) as List;
    return jsonResponse;
  }

  Future completeWithdraw(withdrawId, txId) async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/offchain/withdrawal/$withdrawId/$txId");
    var response = await http.put(url, headers: {"x-api-key": apikey});

  }

  Future<Map> deleteWithdraw(id) async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/offchain/withdrawal/$id", {"revert": "true"});
    var response = await http.delete(url, headers: {"x-api-key": apikey});

    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

  Future<Map> getTransactionByReference(reference) async {
    var url = Uri.https("api-eu1.tatum.io", "/v3/ledger/transaction/reference/$reference");
    var response = await http.get(url, headers: {"x-api-key": apikey});

    var jsonResponse = convert.jsonDecode(response.body) as Map;
    return jsonResponse;
  }

}


