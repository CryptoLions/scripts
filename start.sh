#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/scripts/
#
###############################################################################


EOSIOBINDIR=/path/to/eos/bin
DATADIR=/path/to/data-dir

$EOSIOBINDIR/eosiod --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid

#$EOSIOBINDIR/eosiod --replay --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
#$EOSIOBINDIR/eosiod --enable-stale-production true --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
