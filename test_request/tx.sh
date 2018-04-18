#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# For testing Transaction in EOS Junlge test network
#
# https://github.com/CryptoLions/
#
################################################################################

SERVER=$1
LIMIT=$2

i=0
loop=true

RQ_RECIVED=0
RQ_FAILED=0
while $loop
do
    i=$(($i+1))
    response=$(curl --write-out %{http_code} --silent --output /dev/null http://$SERVER/v1/chain/get_info)

    if [ $response -eq 200 ]; then
        RQ_RECIVED=$(($RQ_RECIVED+1))
    else
        RQ_FAILED=$(($RQ_FAILED+1))
    fi

    if [ $i -ge $LIMIT ]; then
        loop=false
    fi
done
echo "$RQ_RECIVED $RQ_FAILED"
