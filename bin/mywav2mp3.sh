#!/bin/bash

for i in *.wav; do
    old="$i";
    new="${i/.wav/.mp3}";
    ffmpeg -loglevel quiet -i "$old" -q:a 5 -map a "$new";
    echo "$old converted."
done

rm *.wav
