#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/scripts/
#
###############################################################################


EOSIOBINDIR=/home/eos-dawn-v3.0.0/eos/build/programs
DATADIR=/path/to/data-dir

$EOSIOBINDIR/nodes/nodes --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid

#$EOSIOBINDIR/nodes/nodes --replay --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
#$EOSIOBINDIR/nodes/nodes --enable-stale-production true --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
