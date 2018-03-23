#!/bin/bash

DIR="/path/to/data-dir"

    if [ -f $DIR"/eosd.pid" ]; then
        pid=`cat $DIR"/eosd.pid"`
        echo $pid
        kill $pid
        rm -r $DIR"/eosd.pid"
    fi

done
