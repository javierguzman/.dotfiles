# dotfiles

Personal dotfiles for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's inside

| Folder | Description |
|--------|-------------|
| `nvim/` | Neovim config — lazy.nvim, LSP, Treesitter, Telescope, LazyGit |
| `tmux/` | tmux config |
| `zsh/` | Zsh config with Oh-My-Zsh and Powerlevel10k |
| `bash/` | Bash config |
| `alacritty/` | Alacritty terminal — FiraCode Nerd Font, Tokyo Night themes |
| `yabai/` | Yabai window manager — float layout |
| `skhd/` | skhd hotkey daemon — window management shortcuts |
| `bin/` | Shell scripts: `tmux-sessionizer.sh`, `tmux-cht.sh`, `alacritty-theme-toggle.sh` |
| `stow/` | Stow config |

## Requirements

- macOS
- [Homebrew](https://brew.sh)
- [GNU Stow](https://www.gnu.org/software/stow/) — `brew install stow`
- [Nerd Font](https://www.nerdfonts.com/) — FiraCode Nerd Font recommended

## Install

```bash
git clone https://github.com/javierguzman/.dotfiles ~/.dotfiles
cd ~/.dotfiles
bash setup.sh
```

`setup.sh` runs stow on all folders, symlinking configs to their correct locations under `~/.config/` and `~/.local/bin/`.

## Neovim

Built on [lazy.nvim](https://github.com/folke/lazy.nvim). Plugins install automatically on first launch.

**LSP support:** TypeScript, JavaScript, React, React Native, Go, Rust, C/C++, Python, Elixir, HTML, CSS, Tailwind, YAML/Kubernetes, Terraform, Ansible, Markdown, Lua

**Key plugins:** Telescope, Treesitter, nvim-cmp, Mason, lspsaga, gitsigns, nvim-tree, LazyGit, kubectl.nvim, render-markdown.nvim

## Window Management

[Yabai](https://github.com/koekeishiya/yabai) + [skhd](https://github.com/koekeishiya/skhd) in float mode.

Start services:
```bash
yabai --start-service
skhd --start-service
```

Both require **Accessibility** permission in System Settings → Privacy & Security → Accessibility.

## Terminal Theme

Alacritty ships with Tokyo Night Dark by default. Toggle between dark and light:

```bash
theme
```

## Project Switcher

Uses [tmux-sessionizer](bin/.local/bin/tmux-sessionizer.sh) to fuzzy-find projects in `~/Projects/` and open each in a dedicated tmux session.

```
Ctrl+Z        Open project picker (shell)
Space+F       Open project picker (nvim)
```

## Shortcuts

See [SHORTCUTS.md](https://github.com/javierguzman/dev-machine-setup/blob/main/SHORTCUTS.md) in the dev-machine-setup repo for the full cheatsheet — tmux, Neovim, and window management.

.
