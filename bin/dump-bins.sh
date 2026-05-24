#!/bin/bash

LOCATION=~/random-conf/package-dump

if $ISDEB; then
    dpkg -l > $LOCATION
else
    rpm -qa > $LOCATION
fi
