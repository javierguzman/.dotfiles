# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
zsh-autosuggestions
kubectl
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ssh="TERM=xterm ssh"
alias coreserver="ssh coreserver"
alias theme="alacritty-theme-toggle.sh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/postgresql@15/bin:/Users/javierguzman/.local/bin:$PATH"
export PGDATA='/usr/local/var/postgres'
export AWS_DEFAULT_PROFILE=terraform

bindkey -s ^z "tmux-sessionizer.sh\n"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(pyenv init --path)"

# SSH AGENT FOR YUBIKEY
export SSH_ENV="$HOME/.ssh/agent.env" # custom path we choose it

# macOS ships an ssh-agent/ssh-add without FIDO2 support; Homebrew's build has it.
# Linux's distro-packaged openssh already has FIDO2 support built in.
if [[ "$OSTYPE" == darwin* ]]; then
  SSH_AGENT_BIN="/opt/homebrew/bin/ssh-agent"
  SSH_ADD_BIN="/opt/homebrew/bin/ssh-add"
  PKCS11_PROVIDER_GLOB='/opt/homebrew/lib/libykcs*.dylib,/opt/homebrew/Cellar/yubico-piv-tool/*/lib/*.dylib'
  PKCS11_PROVIDER='/opt/homebrew/lib/libykcs11.dylib'
else
  SSH_AGENT_BIN="ssh-agent"
  SSH_ADD_BIN="ssh-add"
  PKCS11_PROVIDER_GLOB='/usr/lib/x86_64-linux-gnu/libykcs*.so'
  PKCS11_PROVIDER='/usr/lib/x86_64-linux-gnu/libykcs11.so'
fi

function start_ssh_agent() {
  echo "Starting new ssh-agent..."
  "$SSH_AGENT_BIN" -s -P "$PKCS11_PROVIDER_GLOB" > "$SSH_ENV"
  chmod 600 "$SSH_ENV"
  source "$SSH_ENV" > /dev/null

  echo "Adding YubiKey PIV key to ssh-agent..."
  "$SSH_ADD_BIN" -s "$PKCS11_PROVIDER"

  echo "Adding YubiKey FIDO2 resident keys to ssh-agent..."
  "$SSH_ADD_BIN" -K
}

# Load existing agent if available and alive
if [ -f "$SSH_ENV" ]; then
  source "$SSH_ENV" > /dev/null
  if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
    start_ssh_agent
  fi
else
  start_ssh_agent
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/javierguzman/.cache/lm-studio/bin"
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="$(brew --prefix llvm)/bin:$PATH"
