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
