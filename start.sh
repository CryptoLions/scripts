#!/bin/bash
################################################################################  
#  
# Scrip Created by http://CryptoLions.io  
#  
###############################################################################  

EOSIOBINDIR=/path/to/eos/bin
DATADIR=/path/to/data-dir

$EOSIOBINDIR/eosiod --replay --enable-stale-production true --data-dir $DATADIR  > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
