#!/usr/bin/env bash

CONFIG="$HOME/.config/alacritty/alacritty.toml"

if grep -q "tokyo-night-dark" "$CONFIG"; then
    sed -i '' 's|tokyo-night-dark|tokyo-night-light|' "$CONFIG"
    echo "Switched to Tokyo Night Light"
else
    sed -i '' 's|tokyo-night-light|tokyo-night-dark|' "$CONFIG"
    echo "Switched to Tokyo Night Dark"
fi
