#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input video>"
  exit 1
fi

input_video="$1"
output_file="${input_video%.*}-fixed.mp4"

# Get the rotation metadata of the input video
rotation=$(ffprobe -v error -select_streams v:0 -show_entries stream_tags=rotate -of default=nw=1:nk=1 "$input_video")

# Remove the rotation metadata if it exists
if [ ! -z "$rotation" ]; then
  echo "Found rotation metadata: $rotation"
  ffmpeg -i "$input_video" -map_metadata -1 -vf "transpose=${rotation}" -c:a copy "$output_file"
else
  echo "No rotation metadata found"
  ffmpeg -i "$input_video" -c copy "$output_file"
fi
