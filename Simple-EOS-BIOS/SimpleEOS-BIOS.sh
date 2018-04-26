#!/bin/bash
###########################################################################
#
# Created by
# Eric, EOSIO.se
# Bohdan, CryptoLions.io
#
# params (disabled)
# $1 name of network
# $2 full path to eos-folder: /home/eos/eos/dawn3-v3.0.0/eos
# $3 p2p port for nodeos
# $4 api port for nodeos
# $5 bios p2p port for nodeos
# $6 bios api port for nodeos
# $7 wallet port

# This script assumes that you have manually built eos
## cd && mkdir eos eos/dawn3-v3.0.0 && cd eos/dawn3-v3.0.0
## git clone https://github.com/eosio/eos --recursive
## cd eos && git checkout tags/dawn-v3.0.0
## git submodule update --init --recursive
## ./eosio_build.sh
##
#
# To check script Signature
# ./SimpleEOS-BIOS.sh -hash
##############################################################################

# params
#TESTNET_NAME=$1
#EOS_DIR=$2
#NODE01_P2P_PORT=$3
#NODE01_API_PORT=$4
#BIOS_P2P_PORT=$5
#BIOS_API_PORT=$6
#WALLET_PORT=$7


SNAPSHOT_URL="https://raw.githubusercontent.com/eosdac/airdrop/master/snapshots/snapshot_290.csv"

#test params
TESTNET_NAME="testNet"
#EOS_DIR="/home/eos-DAWN-2018-04-23-ALPHA/eos"
EOS_DIR="/home/eos-dawn-3.0.0/eos"
NODE01_P2P_PORT="33339"
NODE01_API_PORT="33338"
BIOS_P2P_PORT="44449"
BIOS_API_PORT="44448"
WALLET_PORT="55555"


# variables
GENESIS_CHAIN_ID='trinity'
HOST="127.0.0.1"
WALLET_HOST="127.0.0.1"

#snapshot tx
SNAPSHOT_DROP_PAUSE_AFTER=500
SNAPSHOT_DROP_PAUSE_FOR=3

#-------------------------------------------------------------------
TESTNET_DIR=$(pwd)

#Created automatically
BIOS_PUB_KEY=""
BIOS_PRIV_KEY=""
BIOS_PROD_NAME="eosio"
BIOS_AGENT_NAME="Eosio"


# paths
EOS_BUILD_DIR=$EOS_DIR/build
CONTRACTS_FOLDER="$EOS_BUILD_DIR/contracts"
CLEOS=$EOS_BUILD_DIR/programs/cleos/cleos
NODEOS=$EOS_BUILD_DIR/programs/nodeos/nodeos

MAIN_DIR="$TESTNET_DIR/$TESTNET_NAME"
BIOS_DIR="$MAIN_DIR/bios"
NODE01_DIR="$MAIN_DIR/node01"
WALLET_DIR="$MAIN_DIR/wallet"

# Bios scrpt signature
HASH_STR=($(sha1sum $0))
HASH=${HASH_STR[0]}

if [ "$1" == "-hash" ]; then
    echo $HASH
    exit
fi

## ???????????? HOW PUT BIOS SCRIPT HASH IN 1 Block ??

# functions
function AddZerosToNums {
    NUMBER=$1
    MIN_LEN=$2
    ADDZEROS=$(($MIN_LEN - ${#NUMBER}))
    for ((x=0; x < $ADDZEROS; x++)); do
        NUMBER="0"$NUMBER
    done
    echo $NUMBER
}

#-------------------------------------------------

# Generate Bios Key
KEY=( $($CLEOS create key) )
BIOS_PRIV_KEY=${KEY[2]}
BIOS_PUB_KEY=${KEY[5]}


# create folders and files
mkdir $TESTNET_DIR"/"$TESTNET_NAME
cd $TESTNET_DIR"/"$TESTNET_NAME
mkdir "tmp"

mkdir $WALLET_DIR $BIOS_DIR $NODE01_DIR
touch $WALLET_DIR/start.sh $WALLET_DIR/stop.sh cleos.sh $BIOS_DIR/start.sh $BIOS_DIR/stop.sh $BIOS_DIR/cleos.sh $NODE01_DIR/start.sh $NODE01_DIR/stop.sh $NODE01_DIR/cleos.sh


#mkdir wallet data-dir config-dir bios bios/data-dir bios/config-dir
#touch wallet/start.sh start.sh cleos.sh bios/start.sh bios/cleos.sh


# start.sh bios
echo "#!/bin/bash" > bios/start.sh
echo "NODEOS=$NODEOS" >> bios/start.sh
echo "DATADIR=$BIOS_DIR" >> bios/start.sh
echo "\$DATADIR/stop.sh" >> bios/start.sh
echo "\$NODEOS --data-dir \$DATADIR --config-dir \$DATADIR \$@ > \$DATADIR/stdout.txt 2> \$DATADIR/stderr.txt &  echo \$! > \$DATADIR/nodeos.pid" >> bios/start.sh
chmod u+x bios/start.sh

# stop.sh bios
echo "#!/bin/bash" > bios/stop.sh
echo "DIR=$BIOS_DIR" >> bios/stop.sh
echo '
    if [ -f $DIR"/nodeos.pid" ]; then
        pid=$(cat $DIR"/nodeos.pid")
        echo $pid
        kill $pid
        rm -r $DIR"/nodeos.pid"

        echo -ne "Stoping Nodeos"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rNodeos stopped. \n"

    fi
    ' >>  bios/stop.sh
chmod u+x bios/stop.sh

# start.sh node01
echo "#!/bin/bash" > node01/start.sh
echo "NODEOS=$NODEOS" >> node01/start.sh
echo "DATADIR=$NODE01_DIR" >> node01/start.sh
echo "\$DATADIR/stop.sh" >> node01/start.sh
echo "\$NODEOS --data-dir \$DATADIR --config-dir \$DATADIR \$@ > \$DATADIR/stdout.txt 2> \$DATADIR/stderr.txt &  echo \$! > \$DATADIR/nodeos.pid" >> node01/start.sh
chmod u+x node01/start.sh

# stop.sh node01
echo "#!/bin/bash" > node01/stop.sh
echo "DIR=$NODE01_DIR" >> node01/stop.sh
echo '
    if [ -f $DIR"/nodeos.pid" ]; then
        pid=$(cat $DIR"/nodeos.pid")
        echo $pid
        kill $pid
        rm -r $DIR"/nodeos.pid"

        echo -ne "Stoping Nodeos"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rNodeos stopped. \n"

    fi
    ' >>  node01/stop.sh
chmod u+x node01/stop.sh

# start.sh wallet
echo "#!/bin/bash" > wallet/start.sh
echo "DATADIR=$WALLET_DIR" >> wallet/start.sh
echo "\$DATADIR/stop.sh" >> wallet/start.sh
echo "$EOS_BUILD_DIR/programs/keosd/keosd --data-dir \$DATADIR --http-server-address $WALLET_HOST:$WALLET_PORT \$@ & echo \$! > \$DATADIR/wallet.pid" >> wallet/start.sh
chmod u+x wallet/start.sh

# stop.sh wallet
echo "#!/bin/bash" > wallet/stop.sh
echo "DIR=$WALLET_DIR" >> wallet/stop.sh
echo '
    if [ -f $DIR"/wallet.pid" ]; then
        pid=$(cat $DIR"/wallet.pid")
        echo $pid
        kill $pid
        rm -r $DIR"/wallet.pid"

        echo -ne "Stoping Wallet"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rWallet stopped. \n"

    fi
    ' >>  wallet/stop.sh
chmod u+x wallet/stop.sh


# cleos.sh bios
echo "#!/bin/bash" > bios/cleos.sh
echo "$CLEOS -H $HOST -p $BIOS_API_PORT --wallet-host localhost --wallet-port $WALLET_PORT \"\$@\"" > bios/cleos.sh
chmod u+x bios/cleos.sh

# cleos.sh node01
echo "#!/bin/bash" > cleos.sh
echo "$CLEOS -H $HOST -p $NODE01_API_PORT --wallet-host localhost --wallet-port $WALLET_PORT \"\$@\"" >> node01/cleos.sh
chmod u+x node01/cleos.sh

# cleos.sh
echo "#!/bin/bash" > cleos.sh
echo "$CLEOS -H $HOST -p $NODE01_API_PORT --wallet-host localhost --wallet-port $WALLET_PORT \"\$@\"" >> cleos.sh
chmod u+x cleos.sh


# Create chain id
HEXVAL=$(xxd -pu <<< "$GENESIS_CHAIN_ID")
GENESIS_CHAIN_ID=$(AddZerosToNums $HEXVAL 64)
#GENESIS_CHAIN_ID=$(echo "$HEXVAL")


# genesis.json
DATE=`date -u "+%Y-%m-%dT%H:%M:%S"`
echo '{ "initial_key": "'$BIOS_PUB_KEY'",
	"initial_timestamp": "'$DATE'",
	"immutable_parameters": {
		"min_producer_count": 21
	},
	"initial_configuration": {
	    "base_per_transaction_net_usage": 100,
	    "base_per_transaction_cpu_usage": 500,
	    "base_per_action_cpu_usage": 1000,
	    "base_setcode_cpu_usage": 2097152,
	    "per_signature_cpu_usage": 100000,
	    "per_lock_net_usage": 32,
	    "context_free_discount_cpu_usage_num": 20,
	    "context_free_discount_cpu_usage_den": 100,
	    "max_transaction_cpu_usage": 10485760,
	    "max_transaction_net_usage": 104857,
	    "max_block_cpu_usage": 104857600,
	    "target_block_cpu_usage_pct": 1000,
            "max_block_net_usage": 1048576,
	    "target_block_net_usage_pct": 1000,
	    "max_transaction_lifetime": 3600,
	    "max_transaction_exec_time": 0,
	    "max_authority_depth": 6,
	    "max_inline_depth": 4,
	    "max_inline_action_size": 4096,
	    "max_generated_transaction_count": 16
	},

	"initial_chain_id": "'$GENESIS_CHAIN_ID'"
}' > genesis.json


#config.ini bios
echo "#!/bin/bash" > bios/config.ini
echo '#Config Bios
    get-transactions-time-limit = 3
    genesis-json = "'$MAIN_DIR'/genesis.json"
    block-log-dir = "'$BIOS_DIR'/blocks"

    http-server-address = 0.0.0.0:'$BIOS_API_PORT'
    p2p-listen-endpoint = 0.0.0.0:'$BIOS_P2P_PORT'
    p2p-server-address = '$HOST':'$BIOS_P2P_PORT'
    access-control-allow-origin = *

    allowed-connection = any

    log-level-net-plugin = info
    max-clients = 25
    connection-cleanup-period = 30
    network-version-match = 0
    sync-fetch-span = 1000
    enable-stale-production = false
    required-participation = 33

    plugin = eosio::producer_plugin
    plugin = eosio::chain_api_plugin
    plugin = eosio::account_history_plugin
    plugin = eosio::account_history_api_plugin

    private-key = ["'$BIOS_PUB_KEY'","'$BIOS_PRIV_KEY'"]
    producer-name = '$BIOS_PROD_NAME'
    agent-name = '$BIOS_AGENT_NAME'

    p2p-peer-address = '$HOST':'$NODE01_P2P_PORT'

    ' >> bios/config.ini


#config.ini node01
echo "#!/bin/bash" > node01/config.ini
echo '#Config Bios
    get-transactions-time-limit = 3
    genesis-json = "'$MAIN_DIR'/genesis.json"
    block-log-dir = "'$NODE01_DIR'/blocks"

    http-server-address = 0.0.0.0:'$NODE01_API_PORT'
    p2p-listen-endpoint = 0.0.0.0:'$NODE01_P2P_PORT'
    p2p-server-address = '$HOST':'$NODE01_P2P_PORT'
    access-control-allow-origin = *

    allowed-connection = any

    log-level-net-plugin = info
    max-clients = 25
    connection-cleanup-period = 30
    network-version-match = 0
    sync-fetch-span = 1000
    enable-stale-production = false
    required-participation = 33

    plugin = eosio::chain_api_plugin
    plugin = eosio::account_history_plugin
    plugin = eosio::account_history_api_plugin

    p2p-peer-address = '$HOST':'$BIOS_P2P_PORT'

    ' >> node01/config.ini



#Start wallet
./wallet/start.sh

#creating Wallet
WALLETPASS=$(./cleos.sh wallet create)

#For testing storing wallet Password
#echo $WALLETPASS > ../wallet_pass.txt

#import BIOS keys in Wallet
./cleos.sh wallet import $BIOS_PRIV_KEY

#Run Bios Node with --enable-stale-production
./bios/start.sh --enable-stale-production

echo "Nodeos Loading.."
sleep 2


#create account eosio.token (with bios key)
echo -ne "\n-------------Creating account eosio.token--------------------\n"
./bios/cleos.sh create account eosio eosio.token $BIOS_PUB_KEY $BIOS_PUB_KEY -f -p eosio

#create account msig
echo -ne "\n-------------- Creating account eosio.msig -----------------\n"
./bios/cleos.sh create account eosio eosio.msig $BIOS_PUB_KEY $BIOS_PUB_KEY -f -p eosio


#deploy bios Contract
echo -ne "\n---------------- Deploying eosio.bios to eosio ----------------\n"
CONTRACT_USER="eosio"
CONTRACT_NAME="eosio.bios"
./bios/cleos.sh set contract $CONTRACT_USER $CONTRACTS_FOLDER/$CONTRACT_NAME -p eosio


#deploy token Contract
echo -ne "\n-----------------Deploying eosio.token to eosio.token---------------\n"
CONTRACT_USER="eosio.token"
CONTRACT_NAME="eosio.token"
./bios/cleos.sh set contract $CONTRACT_USER $CONTRACTS_FOLDER/$CONTRACT_NAME -p eosio.token

#deploy msig Contract
echo -ne "\n----------------- Deploying eosio.msig to eosio.msig ---------------------\n"
CONTRACT_USER="eosio.msig"
CONTRACT_NAME="eosio.msig"
./bios/cleos.sh set contract $CONTRACT_USER $CONTRACTS_FOLDER/$CONTRACT_NAME -p eosio.msig

echo -ne "\n---------- Preparing new BP list and BP accounts -----------------\n"
#Initial Producers create accounts and setprods list preparation
PRODUCERS_JSON="{\"version\":1,\"producers\":["
while read -r line
do
    a=(${line//,/ })
    name="${a[0]}"
    key="${a[1]}"

    if [ ! -z "$name" ]; then
        ./bios/cleos.sh create account eosio $name $key $key -p eosio
        PRODUCERS_JSON="$PRODUCERS_JSON{\"producer_name\":\"$name\",\"block_signing_key\":\"$key\"},"
    fi
done < "../initial_producers.csv"

## COMMENT AFTER TESTING EOSIO user need to be reomevd here #!!!!!!!!!!!!!!!!!!!!!!!!!
PRODUCERS_JSON="$PRODUCERS_JSON {\"producer_name\":\"eosio\",\"block_signing_key\":\"$BIOS_PUB_KEY\"}"
##
PRODUCERS_JSON="$PRODUCERS_JSON ]}"


#fi
#cd $TESTNET_DIR"/"$TESTNET_NAME
#echo $PRODUCERS_JSON

echo -ne "\n------- Enabling new BP List --------\n"
./bios/cleos.sh push action eosio setprods "$PRODUCERS_JSON"  -p eosio@active -f

#deploy system Contract
echo -ne "\n------- deploying eosio.system contract --------\n"
CONTRACT_USER="eosio"
CONTRACT_NAME="eosio.system"
./bios/cleos.sh set contract $CONTRACT_USER $CONTRACTS_FOLDER/$CONTRACT_NAME -p eosio -f

echo -ne "\n------- Issue to eosio account 1 000 000 000.0000 EOS --------\n"
./bios/cleos.sh push action eosio issue '{"to":"eosio", "quantity":"1000000000.0000 EOS"}' -p eosio@active -f

echo -ne "\n--- Runing node01 ----\n"
sleep 2
./node01/start.sh
echo "Started."
echo "------------ Loading Distribution List -----------------"

wget $SNAPSHOT_URL -O tmp/snapshot.csv
csvtool col 2,3 tmp/snapshot.csv > tmp/snapshot.txt

echo "------------ Applaying Distribution List -----------------"

SUM=0
ROW=0
echo -ne "Processing snapshot.. \n"
filelines=$(cat tmp/snapshot.txt)
filelines=$(echo "$filelines" | tr -d ".")
TOTAL=$(wc -l < tmp/snapshot.txt)
echo -ne "Snapshot Prepared to drop.\n"


for line in $filelines; do
    addr=($(echo "$line" | tr "," " "))
    ROW=$(($ROW+1))
    SUM=$(( $SUM+${addr[1]} ))

    echo -ne "$ROW / $TOTAL : ${addr[0]} [$username] ${addr[1]} EOS                                            \r"

    username=$(pwgen 9 1 -A -0)
    createAccount=$(./bios/cleos.sh create account eosio $username ${addr[0]} ${addr[0]} -f 2>&1)

    if [[ $createAccount =~ .*Error.* ]]; then
	echo "${addr[0]},${addr[1]}" >> ../error_accounts.log
    else
	issueTransfer=$(./bios/cleos.sh transfer eosio $username ${addr[1]} 'ERC20' -f 2>&1)
	if [[ $issueTransfer =~ .*Error.* ]]; then
	    #Try Again with Pause
	    echo -ne "----------  TX Failed. Retry     -------------                       \r"
	    sleep $SNAPSHOT_DROP_PAUSE_FOR

	    issueTransfer=$(./cleos.sh transfer eosio $username ${addr[1]} 'ERC20' -f 2>&1)
		if [[ $issueTransfer =~ .*Error.* ]]; then
		    echo -ne "----------   TX Failed. Logged  -------------                 \r"
		    echo "$username,${addr[0]},${addr[1]}" >> ../error_transfer.log
		fi
	fi
    fi



    if (( $ROW % $SNAPSHOT_DROP_PAUSE_AFTER == 0 )); then
	echo -ne "\n---------- Pause between $SNAPSHOT_DROP_PAUSE_AFTER users -------------\n"
	#break
    	sleep $SNAPSHOT_DROP_PAUSE_FOR
    fi
done
echo "========================================================================================="
echo -ne "Total SUM: $SUM \n\n"

#Removing
rm -rf tmp
./wallet/stop.sh
rm -f wallet/default.wallet
./wallet/start.sh
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "-= FINISHED =- "
exit

