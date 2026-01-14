#!/bin/bash

a=$( ip addr | grep "tun0" )
if [ "$a" == "" ]; then
    echo ""
else
    echo "VPN"
fi
