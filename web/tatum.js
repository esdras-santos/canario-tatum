const http = require("https");

const apikey = 'cb4f36d4-83f2-4c7f-9f24-e9fe60d470c9';



async function generateWallet(mnemonic,coinName){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/${coinName}/wallet?mnemonic=${mnemonic}`,
    "headers": {
      "x-api-key": apikey
    }
  };

  const value = " ";
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.end();
  return value
}

async function generateEtherWallet(mnemonic){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/ethereum/wallet?mnemonic=${mnemonic}`,
    "headers": {
      "x-testnet-type": "rinkeby",
      "x-api-key": apikey
    }
  };
  let value = ' ';
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.end();
  return value
}

async function generateEtherPrivKey(mnemonic){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/ethereum/wallet/priv",
    "headers": {
      "content-type": "application/json",
      "x-testnet-type": "rinkeby",
      "x-api-key": apikey
    }
  };

  let value = " ";
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.write(JSON.stringify({
    index: 0,
    mnemonic: mnemonic,
  }));
  req.end();
  return value
}

async function generateAddress(priv){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/algorand/address/${priv}`,
    "headers": {
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.end();
}

async function getBalance(address){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/algorand/account/balance/${address}`,
    "headers": {
      "x-api-key": apikey
    }
  };
  let value = ' ';
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.end();
  return value 
}

async function getEtherBalance(address){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/ethereum/account/balance/${address}`,
    "headers": {
      "x-testnet-type": "rinkeby",
      "x-api-key": apikey
    }
  };
  let value = ' ';
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.end();
  return value 
}

async function getCurrentBlockNumber(){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": '/v3/algorand/block/current',
    "headers": {
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.end();
}

async function getBlock(blocknumber){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/algorand/block/${blocknumber}`,
    "headers": {
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.end();
}

async function sendAlgo(from, to, fee, amount, note, fromPrivkey){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/algorand/transaction",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  let value = ' ';

  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.write(JSON.stringify({
    from: from,
    to: to,
    fee: fee,
    amount: amount,
    note: note,
    fromPrivateKey: fromPrivkey
  }));
  req.end();
  return value
}

async function sendEther(to, amount, fromPrivkey){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/ethereum/transaction",
    "headers": {
      "content-type": "application/json",
      "x-testnet-type": "rinkeby",
      "x-api-key": apikey
    }
  };

  let value = ' ';
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.write(JSON.stringify({
    data: '',
    to: to,
    currency: 'ETH',
    amount: amount,
    fromPrivateKey: fromPrivkey
  }));
  req.end();
  return value
}

async function getTransaction(txid){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/algorand/transaction/${txid}`,
    "headers": {
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.end();
}

async function getTransactionBetween(from, to){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/algorand/transactions/${from}/${to}?limit=5&next=ywAAAAAAAAAAAAAA`,
    "headers": {
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.end();
}

async function broadcastTransaction(txdata, sigId){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/algorand/broadcast",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.write(JSON.stringify({
    txData: txdata,
    signatureId: sigId
  }));
  req.end();
}

async function generateServiceAccount(externalId){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/ledger/account",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.write(JSON.stringify({
    currency: "ALGO",
    accountingCurrency: "USD",
    customer:{
      "externalId": externalId
    }
  }));
  req.end();
}

async function generateUserAccount(externalId, address, currency){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/ledger/account",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.write(JSON.stringify({
    currency: currency,
    address: address,
    accountingCurrency: "USD",
    customer:{
      "externalId": externalId
    }
  }));
  req.end();
}

// async generateDepositAddress(externalId){
//   const options = {
//     "method": "POST",
//     "hostname": "api-eu1.tatum.io",
//     "port": null,
//     "path": `/v3/offchain/account/${externalId}/address`,
//     "headers": {
//       "content-type": "application/json",
//       "x-api-key": apikey
//     }
//   };
  
//   const req = http.request(options, function (res) {
//     const chunks = [];
  
//     res.on("data", function (chunk) {
//       chunks.push(chunk);
//     });
  
//     res.on("end", function () {
//       const body = Buffer.concat(chunks);
//       console.log(body.toString());
//     });
//   });
  
//   // req.write(JSON.stringify({
//   //   from: from,
//   //   to: to,
//   //   fee: fee,
//   //   amount: amount,
//   //   note: note,
//   //   fromPrivateKey: fromPrivkey
//   // }));
//   req.end();
// }

// webhook
async function notifyIncomingTransations(id, address){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/subscription",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.write(JSON.stringify({
    attr:{
      "id": id,
      "url": "https://webhook.site"
    },
    type: address
  }));
  req.end();
}

async function accountsWithBalances(id){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/ledger/account/customer/${id}?pageSize=50`,
    "headers": {
      "x-api-key": apikey
    }
  };
  let value = " ";
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.end(); 
  return value
}

async function recentTransactions(id){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/ledger/transaction/customer?pageSize=50",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.write(JSON.stringify({
    id: id
  }));
  req.end();
}

async function trade(currency1Id, currency2Id, price, amount, pair, type){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/trade",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
    const value = ' ';
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.write(JSON.stringify({
    type: type,
    price: price,
    amount: amount,
    pair: pair,
    currency1AccountId: currency1Id,
    currency2AccountId: currency2Id,
  }));
  req.end();
  return value
}

async function sellTrade(currency1Id, currency2Id, price, amount, pair){
  const options = {
    "method": "POST",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": "/v3/trade",
    "headers": {
      "content-type": "application/json",
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.write(JSON.stringify({
    type: "SELL",
    price: price,
    amount: amount,
    pair: pair,
    currency1AccountId: currency1Id,
    currency2AccountId: currency2Id,
  }));
  req.end();
}

async function blockAges(accountId){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/ledger/account/block/${accountId}?pageSize=10`,
    "headers": {
      "x-api-key": apikey
    }
  };
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      console.log(body.toString());
    });
  });
  
  req.end();
}

async function openTrades(type){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/trade/${type}?pageSize=10`,
    "headers": {
      "x-api-key": apikey
    }
  };
  let value = " "
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.end();
  return value
}

async function myOpenTrades(id){
  const options = {
    "method": "GET",
    "hostname": "api-eu1.tatum.io",
    "port": null,
    "path": `/v3/trade/${id}`,
    "headers": {
      "x-api-key": apikey
    }
  };
  let value = " "
  
  const req = http.request(options, function (res) {
    const chunks = [];
  
    res.on("data", function (chunk) {
      chunks.push(chunk);
    });
  
    res.on("end", function () {
      const body = Buffer.concat(chunks);
      value = body.toString();
    });
  });
  
  req.end();
  return value
}



