#!/usr/bin/env bash
# Pick a project and go to its tmux session.
# The projects folder is ~/Documents/projects when it exists, else ~/Projects.
# Set PROJECTS_DIR to use a different folder.
# A new session gets three windows: "editor" (nvim .), "terminal" (a shell),
# and "ai" (an AI agent: "claude" when claude exists, else "cursor agent"
# when cursor exists, else a plain shell).
# When the session exists, the script jumps to it.
# Usage: tmux-sessionizer.sh [project-dir]
#   Shell: Ctrl+z (zshrc)   tmux: Prefix + f (popup, also inside Neovim)

if [[ -z "$PROJECTS_DIR" ]]; then
    if [[ -d "$HOME/Documents/projects" ]]; then
        PROJECTS_DIR="$HOME/Documents/projects"
    else
        PROJECTS_DIR="$HOME/Projects"
    fi
fi

if [[ $# -eq 1 ]]; then
    selected="$1"
else
    selected=$(find "$PROJECTS_DIR/" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z "$selected" ]]; then
    exit 0
fi

if command -v claude > /dev/null 2>&1; then
    ai_cmd="claude"
elif command -v cursor > /dev/null 2>&1; then
    ai_cmd="cursor agent"
else
    ai_cmd=""
fi

# tmux does not allow "." or ":" in session names
selected_name=$(basename "$selected" | tr '.:' '__')

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -n editor -c "$selected"
    # send-keys: after the program exits, the window keeps a shell in the project folder
    tmux send-keys -t "=$selected_name:editor" "nvim ." Enter
    tmux new-window -d -t "=$selected_name:" -n terminal -c "$selected"
    tmux new-window -d -t "=$selected_name:" -n ai -c "$selected"
    if [[ -n "$ai_cmd" ]]; then
        tmux send-keys -t "=$selected_name:ai" "$ai_cmd" Enter
    fi
    tmux select-window -t "=$selected_name:editor"
fi

if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "=$selected_name"
else
    tmux attach-session -t "=$selected_name"
fi
