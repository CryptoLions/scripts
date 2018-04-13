#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# For testing Transaction in EOS Junlge test network
# https://github.com/CryptoLions/scripts/ 
#
# Send transaction from random Sender to random Recever with Random amount and Random Memo
#
# Edit Info about your Node and Wallet Port
# Change SENDERS list with your senders accounts
# (please import senders Keys into your wallet)
# Edit RECEIVERS list with receviers accounts
# Edit STRINGDS - ranndom memo messages
# TX_INTERVAL - interval between transaction in seconds 
#
###############################################################################

#------------Config------------------
EOSIOBINDIR=/home/eos-dawn-v3.0.0/eos/build/programs
WALLETHOST="127.0.0.1"
NODEPORT="8888"
WALLETPORT="8905"

SENDERS=("volcano" "rain" "magic" "surprise" "lottery")
RECEIVERS=("lion" "tiger" "jaguar" "bat" "mowgli" "dragonfly" "elephant2" "mosquito" "wombat" "fox" "gorilla" "honeybadger" "sloth" "langurs" "tokki" "whale" "panther" "tortoise" "galapago" "mpenjati" "cougars" "ladybird" "giraffe" "rhino" "cheetah" "termite" "snake" "tapir" "boar" "spider" "koala" "beaver" "unicorn" "scorpion" "hummingbird" "kangaroo" "dragon" "macaw" "parrot" "pug")
STRINGS=("&#9752;Jungle Bot" "&#9737; Be Free" "&#9736; Test Tx" "&#9733; rnd txt" "&#9732;" "&#9748; Rainforest" "&#9813;Treasure" "&#9760;Bot =)" "&#9762; bot tx" "&#9730; your umbrella?" "&#9728;" "&#9749; cofee" "&#9981; refuel")
TX_INTERVAL=3
CLEOS="$EOSIOBINDIR/cleos/cleos -p $NODEPORT --wallet-host $WALLETHOST --wallet-port $WALLETPORT"

CONTRACT="token"
CURRENCY="JUNGLE"
#-------------------------------------------------

while [ 1 ]
do
    rnd_receiver=${RECEIVERS[$RANDOM % ${#RECEIVERS[@]} ]}
    rnd_sender=${SENDERS[$RANDOM % ${#SENDERS[@]} ]}
    rnd_amount_tmp=$(printf "%05d" $(( ((RANDOM<<15)|RANDOM) % 99999 + 1 )))
    rnd_amount="${rnd_amount_tmp%????}.${rnd_amount_tmp: -4}"
    rnd_memo=${STRINGS[$RANDOM % ${#STRINGS[@]} ]}


    echo $rnd_sender" = >"$rnd_receiver" : "$rnd_amount" - "$rnd_memo" "
    DATA='["'$rnd_sender'", "'$rnd_receiver'", "'$rnd_amount' '$CURRENCY'", "'$rnd_memo'"]'
    $CLEOS push action $CONTRACT transfer "$(echo $DATA)" -p $rnd_sender


    sleep $TX_INTERVAL
done
