#!/bin/bash
if [ -z "$1" ]; then exit; fi

case $1 in
    floorp)
        if ( ! wmctrl -xa floorp); then
            floorp & &>/dev/null
        fi
    ;;
    obsidian)
        if ( ! wmctrl -xa obsidian); then
            obsidian & &>/dev/null
        fi
    ;;
    xfce4-terminal)
        if ( ! wmctrl -xa xfce4-terminal); then
            xfce4-terminal & &>/dev/null
        fi
    ;;
    close)
        wmctrl -c ":ACTIVE:"
    ;;
    *)
        notify-send "Shortcuts" """
        Ctrl+8 - Floorp
        Ctrl+9 - Obsidian
        Ctrl+0 - Terminal
        Ctrl+3 - Cycle app window
        Ctrl+4 - Go to last app

        Ctrl+6 - Close
        Ctrl+' - Maximize
        F12 - Fullscreen
        """
    ;;
esac
