#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/scripts/edit/master/install_heartbeat.sh
#
###############################################################################

#Sources Dir
DIR="/opt/EOSIO"

cd $DIR

#Installing heartbeat
cd plugins

if [[ ! -d producer_heartbeat_plugin ]]; then
    git clone https://github.com/bancorprotocol/eos-producer-heartbeat-plugin.git producer_heartbeat_plugin
else
    cd producer_heartbeat_plugin
    git checkout -f
    git branch -f
    git pull
    git submodule update --init --recursive
    cd ..
fi

#update Plugins CMakeList.txt
cp CMakeLists.txt CMakeLists.txt.bck

Plugin="#Community plugins\nadd_subdirectory(producer_heartbeat_plugin)"
sed '/add_subdirectory[^\n]*/,$!b;//{x;//p;g};//!H;$!d;x;s//&\n\n'"$Plugin"'/' CMakeLists.txt > CMakeLists2.txt
mv CMakeLists2.txt CMakeLists.txt
cd ../

#update nodeos CMakeList.txt
cd programs/nodeos
cp CMakeLists.txt CMakeLists.txt.bck
echo '' >> CMakeLists.txt
echo '#Heartbeat plugin' >> CMakeLists.txt
echo 'target_link_libraries( nodeos PRIVATE -Wl,${whole_archive_flag} producer_heartbeat_plugin -Wl,${no_whole_archive_flag})' >> CMakeLists.txt
cd ../../

