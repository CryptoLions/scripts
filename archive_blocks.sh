#!/bin/bash  
################################################################################  
#  
# Scrip Created by http://CryptoLions.io  
#  
###############################################################################  

PATH_TO_ARCH="."
DATE=`date -d "now" +'%Y_%m_%d-%H_%M'`


./stop.sh
tar cvf $PATH_TO_ARCH/blocks-$DATE.tar blocks
./start.sh
