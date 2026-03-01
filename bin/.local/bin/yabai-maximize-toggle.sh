#!/usr/bin/env bash

WIN_ID=$(yabai -m query --windows --window | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
STATE_FILE="/tmp/yabai-max-${WIN_ID}"

if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
    yabai -m window --grid 8:8:1:1:6:6
else
    touch "$STATE_FILE"
    yabai -m window --grid 1:1:0:0:1:1
fi
