#!/bin/sh

find -H ~/Files -noleaf \( \
    # backups
    -iname "*.bak" -or \
    -iname "~*" -or \
    # screenshots
    -name "*_scrot*.png" -or \
    # latex
    -regextype egrep -regex "^[^.].+\.(swp|swo|aux|fdb_latexmk|fls|lod|tdo|xdv|synctex.gz)$" \) -or \
    # windows' shit
    -name "desktop.ini" -or \
    -name "AlbumArt*" -or \( \
    -name "Thumbs.db*" \) -print -delete
