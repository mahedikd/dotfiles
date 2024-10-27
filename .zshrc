# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Set the directory we want to store tmux plugins
TMUX_PLUGIN_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/tmux/plugins/tpm"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
# Download Tmux Plugin Manager, if it's not there yet
if [ ! -d "$TMUX_PLUGIN_DIR" ]; then
   mkdir -p "$(dirname $TMUX_PLUGIN_DIR)"
   git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light hlissner/zsh-autopair
zinit light kutsan/zsh-system-clipboard
zinit light MichaelAquilina/zsh-you-should-use

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias vi='nvim'
alias vim='nvim'
alias c='clear'
alias htop='btop'
alias nano='nano -lmq'
alias tar_comp='tar -cvzf'
alias tar_decomp='tar -xvzf'
alias vc='verdaccio'

os_id=$(cat /etc/os-release | awk -F= '$1 == "ID" {print $2}')

if [[ "$os_id" == "manjaro" ]]; then
  alias update='sudo pacman -Syu'
  alias update="sudo pacman -Syu"
  alias install="sudo pacman -S"
  alias remove="sudo pacman -Rcns"
  alias clean="sudo pacman -R $(pacman -Qdtq)"
  alias dbox="distrobox"
  alias mongost="docker start mongodb"
  alias mongoed="docker stop mongodb"

elif [[ "$os_id" == "kali" || "$os_id" == "ubuntu" ]]; then
  alias update='sudo apt update'
  alias upgrade='sudo apt upgrade -y'
  alias install='sudo apt install'
  alias remove='sudo apt purge'
  alias aptclean='sudo apt autoremove && sudo apt autoclean && sudo apt clean'
  alias jp='jupyter lab --allow-root --ip="0.0.0.0" --port=8888 > /dev/null 2>&1 &'
  
  if [[ "$os_id" == "kali" ]]; then
    alias burp='java -jar ~/burpsuite/burploaderkeygen.jar > /dev/null 2>&1 &'
    alias kex='echo -ne "\033]0;Starting Server\007" && clear;if HOME=/root;USER=root;sudo -u root LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgcc_s.so.1 nohup vncserver :1 -localhost no -name "NetHunter KeX" >/dev/null 2>&1 </dev/null;then echo "Server started! Closing terminal..";else echo -ne "\033[0;31mServer already started! \n";fi && sleep 2 && exit'
    alias cs='code-server'
    . "/root/.deno/env"
  fi

else
  alias c='clear'
fi

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

