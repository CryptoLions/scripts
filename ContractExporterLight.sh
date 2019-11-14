#!/bin/bash
################################################################################
#
# Script Created by Bohdan Kossak 2019
# http://CryptoLions.io
#
# Smart Contracts Data exporter For EOSIO Blockchains
#
# usage: ./ContractExporterLight.sh <ContractName> [<scope>]
# if scope is not mentioned by default is contract name
#
# https://github.com/CryptoLions/
#
################################################################################


if [ "$1" = "" ]; then
    echo -ne "\n\nUSAGE:\n\n$0 <contractName> [<scope> - def contract name]\n\n"
    exit;
fi

CONTRACTNAME=$1

scope=$CONTRACTNAME

if [ "$2" != "" ]; then
    scope=$2
fi

echo "Extracting Contract: $1"

if [[ ! -d  $CONTRACTNAME ]]; then
    mkdir $CONTRACTNAME
fi

./cleos.sh get code $1 -c $CONTRACTNAME/$CONTRACTNAME.wasm --wasm -a $CONTRACTNAME/$CONTRACTNAME.abi

echo "Exporting Tables [Scope: $scope]:"

tables=( $(cat $CONTRACTNAME/$CONTRACTNAME.abi | jq -r '.tables[] | .name') )

for tbl in ${tables[@]}; do

    echo -ne "Table: $tbl \r"
    ./cleos.sh get table $CONTRACTNAME $scope $tbl -l 10000000 > $CONTRACTNAME/table_"$tbl"_"$scope".json

done


