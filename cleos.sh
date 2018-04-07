#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/scripts/
#
###############################################################################

EOSIOBINDIR=/home/eos-dawn-v3.0.0/eos/build/programs
WALLETHOST="127.0.0.1"
NODEPORT="8887"
WALLETPORT="8887"

$EOSIOBINDIR/cleos/cleos -p $NODEPORT --wallet-host $WALLETHOST --wallet-port $WALLETPORT $@
