#!/bin/bash

if [ $# -ne 6 ]; then
  echo "Usage: $0 <input video> <start minute> <start second> <end minute> <end second> <degrees>"
  exit 1
fi

input_video="$1"
start_minute="$2"
start_second="$3"
end_minute="$4"
end_second="$5"
degrees="$6"

# Remove any existing rotation metadata from the input video file
./remove-rotation-metadata.sh "$input_video"

# Extract the clip from the input video file
clip_file="${input_video%.*}-clip.mp4"
./extract-from-clip.sh "${input_video%-fixed.*}.mp4" "$start_minute" "$start_second" "$end_minute" "$end_second" "$clip_file"

# Rotate the extracted clip
output_file="${clip_file%.*}-rotated.mp4"
./rotate-degrees.sh "$clip_file" "$degrees" "$output_file"
