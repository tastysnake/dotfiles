#!/bin/bash

edit="$1"

case "$edit" in

    # If you want to edit,
    # just the newest file
    -e) vim -c "setlocal textwidth=80" `ls -1c *.txt | head -n 1`
    ;;

    # else, only create the file
    *)
    today=`date +'%Y.%m.%d'`
    read -p "Type base file name: " -ei "" base

    if [ -z "$base" ]; then
        touch "$today".txt
    else
        touch "$today-$base".txt
    fi
    ;;
esac
