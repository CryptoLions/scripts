#!/bin/bash
################################################################################
#
# Script Created by http://CryptoLions.io
# For EOSIO blockchains
#
# https://github.com/CryptoLions/
#
################################################################################

if [[ ! -d data ]]; then
    mkdir data
fi

getRam(){
    ACC=$1
    ram_usage=$(./cleos.sh get account $ACC -j | jq -r '.ram_usage')

    old_ram_usage=0
    if [[ -f data/$ACC ]]; then
        old_ram_usage_=$(cat data/$ACC)
        old_ram_usage=$((old_ram_usage_*1))
    fi

    dif_ram=$(($ram_usage - $old_ram_usage))

    diff_txt="";
    if [[ old_ram_usage -gt 0 ]] && [[ $dif_ram -ne 0 ]]; then
        if [[ $dif_ram -gt 0 ]]; then
            diff_txt="( +$dif_ram bytes )"
        else
            diff_txt="( $dif_ram bytes )"
        fi
    fi
    echo "$ACC: $ram_usage bytes $diff_txt"
    echo $ram_usage > data/$ACC
}

getRam "testertest11"
getRam "testertest12"
