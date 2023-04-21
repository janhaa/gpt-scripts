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

# Call the remove-rotation.sh script to remove rotation metadata
./remove-rotation.sh "$input_video"

# Call the extract-from-clip.sh script to extract a clip from the video
./extract-from-clip.sh "${input_video%-fixed.*}.mp4" "$start_minute" "$start_second" "$end_minute" "$end_second"

# Call the rotate-video.sh script to rotate the extracted clip
./rotate-video.sh "${input_video%-fixed.*}-clip.mp4" "$degrees"
