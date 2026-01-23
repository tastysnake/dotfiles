#!/bin/bash
# requires xdotool and xprop for window manipulation
#
# clunky, but as written, takes about 11 ms to run,
# so the delay is not noticeable

# don't run as normal script
if [ -z "$1" ]; then exit; fi

########################################
# CUSTOMIZE ACTIONS PER APP
########################################

# you just run the command below on any window you want to customize,
# then just write the list of actions in the ACTIONS array further down

NAME=$(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d\" -f 4)
ACTIONS=()

# basically:
#
# 0 - up
# 1 - down
# 2 - left
# 3 - right
# 4 - no direction

case "$NAME" in
    # floorp
    floorp)
        ACTIONS[0]=toggle_maximize
        ACTIONS[1]=close_window
        ACTIONS[2]=floorp_private
        ACTIONS[3]=floorp_closeright
        ACTIONS[4]=resize_window
    ;;
    # default
    *)
        ACTIONS[0]=toggle_maximize
        ACTIONS[1]=close_window
        ACTIONS[2]=
        ACTIONS[3]=
        ACTIONS[4]=resize_window
    ;;
esac

########################################
# ACTION DEFINITIONS
########################################

function toggle_maximize() {
    wmctrl -b toggle,maximized_vert,maximized_horz -r ":ACTIVE:"
}

function close_window() {
    wmctrl -c ":ACTIVE:"
}

function resize_window() {
    xdotool keydown Alt mousedown 3 
    xdotool keyup Alt
}

function floorp_private() {
    xdotool key Ctrl+Shift+P
}

# requires an extension to recognize the shortcut
function floorp_closeright() {
    xdotool key Alt+Shift+F2
}


########################################
# ACTUALLY RUN
########################################

case $1 in
    up) ${ACTIONS[0]}
    ;;
    down) ${ACTIONS[1]}
    ;;
    left) ${ACTIONS[2]}
    ;;
    right) ${ACTIONS[3]}
    ;;
    *) ${ACTIONS[4]}
    ;;
esac
