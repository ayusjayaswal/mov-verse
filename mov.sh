#!/bin/bash
set -o noglob

random_number=$(od -An -N2 -i /dev/urandom | tr -d ' ' | cut -c1-4)
random_number=$((random_number % 9999 + 1))

search_term="MOV$random_number"
video_links=$(curl -sL --compressed --max-time 10 -H "Accept-Encoding: gzip" \
    "https://www.youtube.com/results?search_query=$search_term" | grep -oP 'watch\?v=\K[^"&]+' | sort -u)
if [ -n "$video_links" ]; then
    selected_video=$(echo "$video_links" | shuf -n 1)
    
    mpv "https://www.youtube.com/watch?v=$selected_video" ||
    { printf "Failed to play video\n"; exit 1; }
else
    printf "No videos found for %s\n" "$search_term"
    exit 1
fi
