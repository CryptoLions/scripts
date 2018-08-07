#!/bin/bash
################################################################################################################
#
# Scrip Created by http://CryptoLions.io
# Sudo contract tests (uncomment one command before run)
#
# https://github.com/CryptoLions/
#
# Block Examples with sudo
# Permissions: http://jungle.cryptolions.io/#block:8660675
# Unregprod: http://jungle.cryptolions.io/#block:8431344
# Transfer: http://jungle.cryptolions.io/#block:8437934
# 
# To unpack actions data use abi_bin_to_json, example:
# serialized data: 103256994d97b1ca80277591e6ea2f32a086010000000000044a554e474c450000
#
# Unserialize: 
# curl --header "Content-Type: application/json" --request POST --data '{"code":"eosio.token","action":"transfer","binargs":"103256994d97b1ca80277591e6ea2f32a086010000000000044a554e474c450000"}' http://jungle.cryptolions.io:18888/v1/chain/abi_bin_to_json
#
# Result: 
#        {"args":{"from":"testingtest1","to":"acryptolions","quantity":"10.0000 JUNGLE","memo":""}}
#
#
# http://CryptoLions.io
################################################################################################################



ACC="testingtest1"
NEWKEY="EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV"

#./cleos.sh get account $ACC


## ------ sudo change Account permissions-------------------

##1.1 prepare changing owner permission to new owner Key transaction:
#./cleos.sh set account permission -s -j -d $ACC owner $NEWKEY > sudo_upd_acc.json

##1.2 prepare changing owner permission to eosio@active Key transaction:
#./cleos.sh set account permission -s -j -d $ACC owner '{"threshold": 1, "accounts": [{"permission": {"actor": "eosio", "permission": "active"}, "weight": 1}]}' > sudo_upd_acc.json

## Make changes in generated sudo_upd_acc.json:
## ref_block_num -> 0
## ref_block_prefix -> 0 

##2. push Sudo exec with cghange permission transaction
#./cleos.sh sudo exec -j eosio sudo_upd_acc.json -p eosio.sudo -p eosio


##--------------------------------------------------------------
## ------ sudo create tx ---------------------------------------

##1. prepare transfer transaction 
#./cleos.sh transfer -s -j -d $ACC acryptolions "10.0000 JUNGLE" > sudo_transf.json

## Make changes in generated sudo_upd_acc.json:
## ref_block_num -> 0
## ref_block_prefix -> 0 

##2. push Sudo exec with transfer transaction
#./cleos.sh sudo exec -j eosio sudo_transf.json -p eosio.sudo -p eosio


##--------------------------------------------------------------
##------- sudo unregproducer -----------------------------------

## 1. prepare unregprod transaction
#./cleos.sh system unregprod -s -j -d $ACC > sudo_unregprof.json

## Make changes in generated sudo_upd_acc.json:
## ref_block_num -> 0
## ref_block_prefix -> 0 

#./cleos.sh sudo exec -j eosio sudo_unregprof.json -p eosio.sudo -p eosio




#========================================

### msig permission [!!! need more tests]
#./cleos.sh set account permission -s -j -d $ACC owner '{"threshold": 1, "accounts": [{"permission": {"actor": "eosio", "permission": "active"}, "weight": 1}]}' > sudo_upd_acc.json

## expiration -> "1970-01-01T00:00:00"
## ref_block_num -> 0
## ref_block_prefix -> 0 

#./cleos.sh sudo exec -s -j -d eosio sudo_upd_acc.json > sudo_upd2_acc.json
## expiration -> enougth to sign by 15 bps
## ref_block_num -> 0
## ref_block_prefix -> 0 

#./cleos.sh multisig propose_trx testsudo1 sudo_producer_permissions.json sudo_upd2_acc.json eosio
