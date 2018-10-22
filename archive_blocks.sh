#!/bin/bash  
################################################################################  
#  
# Scrip Created by http://CryptoLions.io  
#  
# Change PATH_TO_ARCH to place where you woud like to store archives
# Change networkName to your blockchain network name
###############################################################################  

DATA_DIR="/path/to/data-dir"
PATH_FOR_ARCH="/var/www/html/blocks"
BLOCKCHAIN_NAME="networkName"


DATE=`date -d "now" +'%Y_%m_%d-%H_%M'`
echo "Archiving BlockChain $BLOCKCHAIN_NAME [$DATE]"

$DATA_DIR/stop.sh
tar -pcvzf $PATH_FOR_ARCH/blocks-$BLOCKCHAIN_NAME-$DATE.tar.gz $DATA_DIR/blocks
ln -sf $PATH_FOR_ARCH/blocks-$BLOCKCHAIN_NAME-$DATE.tar.gz $PATH_FOR_ARCH/blocks.tar.gz

tar -pcvzf $PATH_FOR_ARCH/state-$BLOCKCHAIN_NAME-$DATE.tar.gz $DATA_DIR/state
ln -sf $PATH_FOR_ARCH/state-$BLOCKCHAIN_NAME-$DATE.tar.gz $PATH_FOR_ARCH/state.tar.gz

$DATA_DIR/start.sh
