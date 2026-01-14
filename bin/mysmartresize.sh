#!/bin/bash

# Function to resize images with best quality
# Use: smartresize input_file width output_directory 

if [ -z "$1" ]; then
    echo "Usage: smartresize input_file width output_dir"
else
    mkdir -p "$3"
    mogrify -path "$3" -filter Triangle -define filter:support=2 -thumbnail "$2" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136\
        -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1\
        -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
fi
