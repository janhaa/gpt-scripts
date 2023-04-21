#!/bin/bash

if [ $# -ne 5 ]; then
  echo "Usage: $0 <input video> <start minute> <start second> <end minute> <end second>"
  exit 1
fi

input_video="$1"
start_minute="$2"
start_second="$3"
end_minute="$4"
end_second="$5"

start_time="$start_minute:$start_second"
end_time="$end_minute:$end_second"

output_file="${input_video%.*}-clip.mp4"

ffmpeg -i "$input_video" -ss "$start_time" -to "$end_time" -c:v copy -c:a copy "$output_file"
