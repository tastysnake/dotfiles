#!/bin/bash
# simple screenshoter

button1="Select"
button2="Whole screen"
button3="Nothing"

type=`xmessage -center -buttons "$button1","$button2","$button3" -default "$button2" -print "What do you want to screenshot?"`

if [ "$type" = "$button1" ]; then
    scrot -s
elif [ "$type" = "$button2" ]; then
    scrot
fi
