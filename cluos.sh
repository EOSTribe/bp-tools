#!/bin/bash
# Change path to match your local path:
CLUOS=/opt/uos/build/programs/cleos/cleos
$CLUOS -u http://api.uos.eostribe.io --wallet-url http://127.0.0.1:7777 "$@"
