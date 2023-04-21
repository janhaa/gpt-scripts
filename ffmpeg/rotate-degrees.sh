#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input video> <degrees>"
  exit 1
fi

input_video="$1"
degrees="$2"
output_file="${input_video%.*}-rotated.mp4"

# Calculate the rotation direction based on the given degrees
if [ "$degrees" -eq 90 ]; then
  transpose="clock"
elif [ "$degrees" -eq 270 ]; then
  transpose="cclock"
else
  echo "Error: unsupported rotation degrees: $degrees"
  exit 1
fi

# Rotate the input video by the given number of degrees
ffmpeg -i "$input_video" -vf "transpose=$transpose" -metadata:s:v rotate="$degrees" -c:a copy "$output_file"
