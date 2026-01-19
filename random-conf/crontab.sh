#!/bin/bash

TAB=$(crontab -l)
DIR=$(dirname "$0")

if [ -n "$(diff <(echo "$TAB") $DIR/crontab )" ]; then
    echo "$TAB" > "$DIR/crontab"
fi
