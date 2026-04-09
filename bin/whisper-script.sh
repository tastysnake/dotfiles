#!/bin/bash

INPUT_FILE="$1"
TEMP_DIR=parts
AUDIOLEN=300
OUTPUT_FILE="$2"
MODEL_DIR=/mnt/Files/WhisperModels
MODEL=large-v3-turbo-q5_0

if [ -z "$INPUT_FILE" ]; then
    echo "Usage: $0 <input_mp3>"
    exit 1
fi

if [ -z "$OUTPUT_FILE" ]; then
    OUTPUT_FILE=transcript.txt
fi

INPUT_EXT=$( echo $INPUT_FILE | rev | cut -d. -f 1 | rev )

mkdir -p "$TEMP_DIR"
rm -f "$OUTPUT_FILE"

echo "Dividing audio file..."
# -segment_time 600: 600 seconds = 10 minutes
ffmpeg -i "$INPUT_FILE" -f segment -segment_time $AUDIOLEN -c copy "$TEMP_DIR/part_%02d.$INPUT_EXT"

echo "Transcribing..."
for part in "$TEMP_DIR"/*.$INPUT_EXT; do
    echo "Processing $part..."
    
    # Run whisper
    whisper-cli -dev 1 -np -nt -pp -m "${MODEL_DIR}/ggml-${MODEL}.bin" "$part" -l es >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE" 
done

echo "Done."

# Optional: Clean up temp files
rm -rf "$TEMP_DIR"
