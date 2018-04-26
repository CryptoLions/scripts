#!/bin/bash

TESTNET_NAME="testNet"

if [ ! -d $TESTNET_NAME ]; then
    echo "Can't find testnet: $TESTNET_NAME"
    exit;
fi

./$TESTNET_NAME/wallet/stop.sh
./$TESTNET_NAME/bios/stop.sh
./$TESTNET_NAME/node01/stop.sh

rm -r $TESTNET_NAME

rm *.log
rm wallet_pass.txt