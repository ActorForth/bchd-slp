# bchd-slp
Investigate suitability of bchd as replacement of slpdb

**PS: This is insecure, use at your own risk.**

## Setup

```bash
make up
```

This sets up self signed CA, builds docker image, and starts the bchd(hardcoded to mainnet) and proxy

Result is grpc-REST proxy running at http://localhost:1337/ (this url shows the swagger stuff)

### debugging

Use `bchctl` like so

```bash
docker exec -it bch-node bchctl getblockchaininfo
```

## Use cases

Current API reference: https://rest.bch.actorforth.org/#/slp

PS: Many of the methods have a "bulk" counterpart, im skipping those here.

### List all SLP tokens

API : GET /slp/list

BCHD Status : Unknown

### List SLP tokens filtered by ids

API : POST /slp/list

BCHD Status : Unknown


### List individual SLP token

API : GET /slp/list/{tokenId}

```
curl -s -X GET "https://rest.bch.actorforth.org/v2/slp/list/259908ae44f46ef585edef4bcc1e50dc06e4c391ac4be929fae27235b8158cf1" -H "accept: */*" | jq .{
  "decimals": 2,
  "timestamp": "2018-10-11 00:39:22",
  "versionType": 1,
  "documentUri": "broccoli.cash",
  "symbol": "BROC",
  "name": "Broccoli",
  "containsBaton": false,
  "id": "259908ae44f46ef585edef4bcc1e50dc06e4c391ac4be929fae27235b8158cf1",
  "documentHash": null,
  "initialTokenQty": 1000,
  "blockCreated": 551647,
  "totalMinted": 1000,
  "totalBurned": 1000,
  "circulatingSupply": 0,
  "timestampUnix": 1539218362
}
```

BCHD status: Supported (data might look different/incomplete)

```
curl -s -X POST "http://10.66.67.5:8081/v1/GetSlpTokenMetadata" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"token_ids\": [    \"JZkIrkT0bvWF7e9LzB5Q3Abkw5GsS+kp+uJyNbgVjPE=\"  ]}" | jq .
{
  "token_metadata": [
    {
      "token_id": "JZkIrkT0bvWF7e9LzB5Q3Abkw5GsS+kp+uJyNbgVjPE=",
      "token_type": "V1_FUNGIBLE",
      "v1_fungible": {
        "token_ticker": "BROC",
        "token_name": "Broccoli",
        "token_document_url": "broccoli.cash",
        "token_document_hash": "",
        "decimals": 2,
        "mint_baton_hash": "",
        "mint_baton_vout": 0
      }
    }
  ]
}
```

Appears to miss on-chain curent state of the token.

### list slp balances for single address

API : GET /slp/balancesForAddress/{address}
example : `curl -X GET "https://rest.bch.actorforth.org/v2/slp/balancesForAddress/bitcoincash:qzlsme93kzdnx5t3g242xyv5sn5wqpfrxy3hq4x0ju" -H "accept: */*"` - does not work cause slpdb is down

BCHD: Supported, can get unspent outputs of each token and then calculate by yourself.
```
curl -s -X POST "http://10.66.67.5:8081/v1/GetAddressUnspentOutputs" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"address\": \"bitcoincash:qzlsme93kzdnx5t3g242xyv5sn5wqpfrxy3hq4x0ju\",  \"include_mempool\": true,  \"include_token_metadata\": true}" | jq .
{
  "outputs": [
    {
      "outpoint": {
        "hash": "lAkyEtInk63KaSXd+b0eWOsIAWYfFiD5L3OLVZa41/I=",
        "index": 2
      },
      "pubkey_script": "dqkUvw3ksbCbM1FxQqqjEZSE6OAFIzGIrA==",
      "value": "546",
      "is_coinbase": false,
      "block_height": 743234,
      "slp_token": {
        "token_id": "TeaeN0qO0hy93UfyM4zA9HncWNqiu+Ec1gTKSI7KDd8=",
        "amount": "1346264750000",
        "is_mint_baton": false,
        "address": "qzlsme93kzdnx5t3g242xyv5sn5wqpfrxyavtwn0vz",
        "decimals": 8,
        "slp_action": "SLP_V1_SEND",
        "token_type": "V1_FUNGIBLE"
      }
    }
  ],
  "token_metadata": [
    {
      "token_id": "TeaeN0qO0hy93UfyM4zA9HncWNqiu+Ec1gTKSI7KDd8=",
      "token_type": "V1_FUNGIBLE",
      "v1_fungible": {
        "token_ticker": "SPICE",
        "token_name": "Spice",
        "token_document_url": "spiceslp@gmail.com",
        "token_document_hash": "",
        "decimals": 8,
        "mint_baton_hash": "",
        "mint_baton_vout": 0
      }
    },
    {
      "token_id": "u1U6wqx68PzU8k+d+sx/klv7FEbG4Yx5ZtuVqNUPs3g=",
      "token_type": "V1_FUNGIBLE",
      "v1_fungible": {
        "token_ticker": "MAZE",
        "token_name": "MAZE",
        "token_document_url": "https://mazetoken.github.io",
        "token_document_hash": "",
        "decimals": 6,
        "mint_baton_hash": "JqAYP29UpQl2XQcKA6pfxUd8ztPbkgpwUHfR7pQhw5U=",
        "mint_baton_vout": 2
      }
    }
  ]
}
```



### list SLP addresses and balances for tokenId

API : GET /slp/balancesForToken/{tokenId}

BCHD: TODO

### list single slp token balance for address

API: /slp/balance/{address}/{tokenId}

BCHD: Should be fine, worst case fetch all token balances for user and filter from that

### Validate single txid

API: /slp/validateTxid/{txid}

BCHD: TODO

### List stats for a single slp token

API: /slp/tokenStats/{tokenId}

BCHD: TODO


### SLP transaction details

API : /slp/txDetails/{txid}

BCHD: TODO

### SLP transactions by tokenId and address

API: /slp/transactions/{tokenId}/{address}

BCHD: TODO

## SLP transactions by address (alpha endpoint)

API: /slp/transactionHistoryAllTokens/{address}

BCHD: TODO

### Total burn count for slp transactions

API: /slp/burnTotal/{transactionId}

BCHD: TODO

