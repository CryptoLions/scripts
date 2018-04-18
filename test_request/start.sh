#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# For testing Transaction in EOS Junlge test network
#
# https://github.com/CryptoLions/
#
################################################################################

SERVER="dev.cryptolions.io:8888"
WORKERS=1000
JOB_PERWORKER=50

declare -A WORK=()
declare -A WORK_RES=()

STARTTIME=$(date +%s.%N)

for i in $(seq 1 $WORKERS);
do
    WORK_RES[$i]="worker_$i"
    ./tx.sh $SERVER $JOB_PERWORKER > ${WORK_RES[$i]} &
    WORK[$i]=$!
    echo "Worker $i started"
done

wait ${WORK[*]}

ENDTIME=$(date +%s.%N)
DIFF=$(echo "$ENDTIME - $STARTTIME" | bc)

REQUEST_OK=0
REQUEST_FAILED=0

for i in $(seq 1 ${#WORK_RES[*]});
do
    data=($(cat ${WORK_RES[$i]}))
    REQUEST_OK=$((REQUEST_OK+${data[0]}))
    REQUEST_FAILED=$((REQUEST_FAILED+${data[1]}))
    rm ${WORK_RES[$i]}
done

echo "================================"
echo "Workers: $WORKERS"

echo "Failed Requests: $REQUEST_FAILED"
echo "OK Requests: $REQUEST_OK"
echo "Total Requests: "$(($REQUEST_OK+$REQUEST_FAILED))

echo "Finished. Time: $DIFF sec."
