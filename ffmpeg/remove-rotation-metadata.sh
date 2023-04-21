#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input video>"
  exit 1
fi

input_video="$1"
output_file="${input_video%.*}-fixed.mp4"

# Check if the video contains rotation metadata
rotation=$(ffprobe -v error -select_streams v:0 -show_entries stream_tags=rotate -of default=nw=1:nk=1 "$input_video")

if [ -z "$rotation" ]; then
  echo "No rotation metadata found, copying input video to output file"
  cp "$input_video" "$output_file"
  exit 0
fi

# Extract the audio and video streams separately
ffmpeg -i "$input_video" -map 0:v -map 0:a -c:v copy -c:a copy -an "${input_video%-fixed.*}-video.mp4"
ffmpeg -i "$input_video" -map 0:v -map 0:a -c:v copy -c:a aac -b:a 128k -vn "${input_video%-fixed.*}-audio.aac"

# Remove the rotation metadata from the video stream
ffmpeg -i "${input_video%-fixed.*}-video.mp4" -map_metadata -1 -metadata:s:v rotate=0 -vf "transpose=$rotation" -c:a copy "$output_file"

# Combine the rotated video stream and the re-encoded audio stream
ffmpeg -i "$output_file" -i "${input_video%-fixed.*}-audio.aac" -map 0:v -map 1:a -c copy "${output_file%.*}-reencoded.mp4"

# Delete intermediate files
rm "${input_video%-fixed.*}-video.mp4" "${input_video%-fixed.*}-audio.aac"

echo "Done. Fixed video saved to: $output_file"
