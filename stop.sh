#!/bin/bash

DIR="/path/to/data-dir"

    if [ -f $DIR"/eosd.pid" ]; then
        pid=`cat $DIR"/eosd.pid"`
        echo $pid
        kill $pid
        rm -r $DIR"/eosd.pid"
        
        echo -ne "Stoping Node"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rNode Stopped.    \n"

    fi


