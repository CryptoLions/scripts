#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# For EOS Junlge testnet
#
# https://github.com/CryptoLions/
#
################################################################################

#!/bin/bash

FROM=$1
TO=$2
#FROM=228300
#TO=244000

LAST_TX_COUNT=0
MAX_TPS=0
echo -ne "\nTesting TPS: \n\n"

for i in $(seq $FROM $TO); do

    block=$(./cleos.sh get block $i)

    COUNT_TX=$(jq '.transactions | length' <<<  $block)

    TPS=$(($COUNT_TX+$LAST_TX_COUNT))

    if [[ $TPS -ge $MAX_TPS ]]; then
        MAX_TPS=$TPS
    fi

    echo -ne "Block: $i  | TX COUNT: $COUNT_TX | CURRENT TPS: $TPS | MAX_TPS: $MAX_TPS                                   \r"
    #echo $block;

    LAST_TX_COUNT=$COUNT_TX

done

    echo -ne "\n"
