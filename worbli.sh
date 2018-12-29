#!/bin/sh
# Change path accordingly:
WORBLI=/opt/worbli/build/programs/worbli/worbli 
$WORBLI -u http://api.worbli.eostribe.io --wallet-url http://127.0.0.1:7777 "$@"

