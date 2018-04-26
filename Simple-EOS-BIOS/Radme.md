# Simple EOS BIOS
  
Created by  
Eric, EOSIO.se  
Bohdan, CryptoLions.io  
  
version 0.0.1  
  
This script assumes that you have manually built eos  
 cd && mkdir eos eos/dawn3-v3.0.0 && cd eos/dawn3-v3.0.0  
 git clone https://github.com/eosio/eos --recursive  
 cd eos && git checkout tags/dawn-v3.0.0  
 git submodule update --init --recursive  
 ./eosio_build.sh  


To check script Signature  
 ./SimpleEOS-BIOS.sh -hash  



# How to use

1. Download files in folder where testNetwill be created.  
2. Edit File initial_producers.csv  with initial producer list  
3. Edit script initial data in SimpleEOS-BIOS.sh  
4. Install tools  
apt install csvtool  
apt install pwgen  

SNAPSHOT_URL="https://raw.githubusercontent.com/eosdac/airdrop/master/snapshots/snapshot_290.csv"

#test params  
TESTNET_NAME="testNet"  
EOS_DIR="/home/eos-dawn-3.0.0/eos"  
BIOS_P2P_PORT="44449"  
BIOS_API_PORT="44448"  
WALLET_PORT="55555"  

NODE01_P2P_PORT="33339"  
NODE01_API_PORT="33338"  


# variables  
GENESIS_CHAIN_ID='trinity'  
HOST="127.0.0.1"  
WALLET_HOST="127.0.0.1"  

#snapshot tx  
SNAPSHOT_DROP_PAUSE_AFTER=500  
SNAPSHOT_DROP_PAUSE_FOR=3  
  
--------------------------------------------  
  
For testing there is break on line 477 to stop importing Erc20 Distribution after first $SNAPSHOT_DROP_PAUSE_AFTER  (def 500) If you like to import all snapshot just comment out this row

Script uses intial EOS Erc20 Distribution using snapshot provided in URL

In case errors  
	- creating account - information logged to error_acount.log file  
	- on transfer EOS - there is second try and if also faild - record to log error_transfer.log  

BIOS EOS key is unknow for everyone. It created in script, used for creating accounts, etc and do not stored and removed in end of script.   
    
===================    
Use clear.sh to remove and stop all nodeos in testNet (change name of net inside script)    
  
To be continued...  
