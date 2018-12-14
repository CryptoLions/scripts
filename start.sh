#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/scripts/
#
###############################################################################


EOSIOBINDIR=/opt/eos/bin
DATADIR=/path/to/data-dir

$EOSIOBINDIR/nodes/nodes  --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid

#$EOSIOBINDIR/nodes --replay --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
#$EOSIOBINDIR/nodes --enable-stale-production true --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
