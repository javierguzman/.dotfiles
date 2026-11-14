#!/usr/bin/env bash
# Pick a project in ~/Projects and go to its tmux session.
# A new session gets three windows: "editor" (nvim .), "ai" (a shell for an
# AI agent), and "terminal" (a shell).
# When the session exists, the script jumps to it.
# Usage: tmux-sessionizer.sh [project-dir]
#   Shell: Ctrl+z (zshrc)   tmux: Prefix + f (popup, also inside Neovim)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/Projects/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

# tmux does not allow "." or ":" in session names
selected_name=$(basename "$selected" | tr '.:' '__')

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -n editor -c "$selected"
    # send-keys: after :q, the window keeps a shell in the project folder
    tmux send-keys -t "=$selected_name:editor" "nvim ." Enter
    tmux new-window -d -t "=$selected_name:" -n ai -c "$selected"
    tmux new-window -d -t "=$selected_name:" -n terminal -c "$selected"
    tmux select-window -t "=$selected_name:editor"
fi

if [[ -n $TMUX ]]; then
    tmux switch-client -t "=$selected_name"
else
    tmux attach-session -t "=$selected_name"
fi
