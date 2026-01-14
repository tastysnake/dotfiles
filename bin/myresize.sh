# use: myresize filename pixel_limit (horizontal) outdir

scriptname=${0##*/}

# print usage if no arguments
if [ -z "$1" ]; then
    echo "Usage: $scriptname input_file width output_dir"
    echo "(handles vertical/horizontal files automatically)"
    exit 1
fi

# file info
filename="$1"
size=`stat -c "%s" "$1"`
res=`identify "$1"|cut -d " " -f 3`
# remember that mmxnn means it has mm horizontal
# pixels and nn vertical ones
res_x="${res%x*}"
res_y="${res#*x}"
outdir="$3"

# limits
# size should be in bytes
size_limit=512000
pixel_limit=$2
alt_pixel_limit=$(( ($pixel_limit * 2) / 3 ))

# actual resizing
function actualresize {
    mogrify -path "$3" -filter Triangle -define filter:support=2 -thumbnail "$2" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136\
        -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1\
        -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
}

# finished message
function showme {
    echo "Finished processing file ${1}"
}

# create dir
mkdir -p "$outdir"

# main logic
# if size < limit, do nothing
if [ "$size" -lt "$size_limit" ]; then
    cp "$filename" "resized-$filename"
else
    # x > y means it's horizontal
    if [ "$res_x" -gt "$res_y" ]; then
        actualresize "$filename" "$pixel_limit" "$outdir"
        mv "$outdir"/"$filename" `pwd`/resized-"$filename"
    else
        actualresize "$filename" "$alt_pixel_limit" "$outdir"
        mv "$outdir"/"$filename" `pwd`/resized-"$filename"
    fi
fi

showme "$filename"
