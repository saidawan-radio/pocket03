#!/bin/bash

extensions=("*.mp3" "*.m4a" "*.ogg" "*.flac" "*.acc" "*.wav" "*.webm" "*.aiff")

mkdir -p ./temp

for ext in "${extensions[@]}"; do
    find "$DOWNLOAD_PATH" -iname "$ext" -exec sh -c '
        input="$1"
        temp="${input}.temp.opus"
        output="${input}.opus"

        ffmpeg -i ${input} -an -c:v copy -frames:v 1 -update 1 "./temp/$(basename ${input})cover.jpg" 2>/dev/null

        if ffmpeg -i "${input}" -c:a libopus -b:a 128k "$temp" 2>/dev/null; then
            mv -f "$temp" "$output"
            opustags -i -y --set-cover "./temp/$(basename ${input})cover.jpg" "${output}"
            echo "Converted: $input"
        else
            rm -f "$temp"
            echo "Failed: $input"
        fi
    ' _ {} \;
done