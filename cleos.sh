#!/bin/bash
# Change path accordingly:
CLEOS=/opt/eos/build/programs/cleos/cleos
$CLEOS -u https://api.eostribe.io --wallet-url http://127.0.0.1:7777 "$@"
