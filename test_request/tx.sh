#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# For testing Transaction in EOS Junlge test network
#
# https://github.com/CryptoLions/
#
################################################################################

CLEOS_PATH="./cleos"

SERVER=$1
PORT=$2
LIMIT=$3
ISCURL=$4


i=0
loop=true

RQ_RECIVED=0
RQ_FAILED=0
while $loop
do
    i=$(($i+1))
    ANSWER_OK=false

    if [[ $ISCURL ]]; then
        response=$(curl --write-out %{http_code} --silent --output /dev/null http://$SERVER:$PORT/v1/chain/get_info)
        if [ $response ]; then
            ANSWER_OK=true
        fi
    else
        response=$(./cleos -H $SERVER -p $PORT get info)
        if [[ "$response" =~ "head_block_time" ]]; then
            ANSWER_OK=true
        fi
    fi

    if [[ $ANSWER_OK ]]; then
        RQ_RECIVED=$(($RQ_RECIVED+1))
    else
        RQ_FAILED=$(($RQ_FAILED+1))
    fi


    if [ $i -ge $LIMIT ]; then
        loop=false
    fi
done
echo "$RQ_RECIVED $RQ_FAILED"
