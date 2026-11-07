#!/usr/bin/env zsh
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="bin,stow,nvim,tmux,bash,zsh,yabai,skhd,alacritty"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES $DOTFILES/install.sh

# Run a private companion dotfiles setup if one happens to exist on this
# machine. Not every machine has one; this is a no-op when it doesn't.
if [[ -x $HOME/.private-dotfiles/setup.sh ]]; then
    $HOME/.private-dotfiles/setup.sh
fi
