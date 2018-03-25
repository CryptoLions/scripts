#!/bin/bash

################################################################################  
#  
# Scrip Created by http://CryptoLions.io  
#  
###############################################################################  


EOSIOBINDIR=/path/to/nodeos/bin/folder
DATADIR=/pat/to/your/data-dir

export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH

$EOSIOBINDIR/nodeos --enable-stale-production true --data-dir $DATADIR --config-dir $DATADIR > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/eosd.pid
