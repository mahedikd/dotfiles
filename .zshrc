# --- Powerlevel10k instant prompt ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- OS Detection ---
if [[ "$(uname)" == "Darwin" ]]; then
    os_id="macos"
    [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    [[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
else
    os_id=$(awk -F= '$1=="ID"{print $2}' /etc/os-release | tr -d '"')
fi

# --- Plugin Directories ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
TMUX_PLUGIN_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/tmux/plugins/tpm"

# --- Ensure Zinit and TPM are Installed ---
[[ -d "$ZINIT_HOME" ]] || { mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" }
[[ -d "$TMUX_PLUGIN_DIR" ]] || { mkdir -p "$TMUX_PLUGIN_DIR" && git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR" }

# --- Zinit and Plugins ---
source "${ZINIT_HOME}/zinit.zsh"
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light hlissner/zsh-autopair
zinit light kutsan/zsh-system-clipboard
zinit light MichaelAquilina/zsh-you-should-use
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo

if [[ "$os_id" != "macos" ]]; then
    [[ "$os_id" == "manjaro" || "$os_id" == "cachyos" ]] && zinit snippet OMZP::archlinux
    zinit snippet OMZP::command-not-found
fi

# --- Completions ---
autoload -Uz compinit && compinit
zinit cdreplay -q

# --- Completion Styling --- 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 
zstyle ':completion:*' menu no zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' 
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --- Prompt ---
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Keybindings --- 
bindkey -e 
bindkey '^p' history-search-backward 
bindkey '^n' history-search-forward 
bindkey '^[w' kill-region

# --- History ---
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
  hist_save_no_dups hist_ignore_dups hist_find_no_dups

# --- Global Aliases ---
if [[ "$os_id" == "macos" ]]; then
    alias ls='gls --color'
    alias ll='gls -la --color'
else
    alias ls='ls --color'
    alias ll='ls -la --color'
fi
alias vim='nvim' 
alias vi='nvim' 
alias c='clear' 
alias nano='nano -lmq' 
alias tarc='tar -cvzf' 
alias tard='tar -xvzf' 
alias lzg='lazygit' 
alias lzd='lazydocker' 
alias venv='source .venv/bin/activate'

# --- OS-specific Aliases and Auto-Installs ---
case "$os_id" in
  macos)
    alias update='brew update && brew upgrade'
    alias install='brew install'
    alias remove=‘brew uninstall’
    alias clean=‘brew cleanup’
    export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"
    ;;

  manjaro|cachyos)
    alias update='sudo pacman -Syu'
    alias install='sudo pacman -S'
    alias remove=’sudo paceman -Rcns’
    alias clean=‘sudo packman -R $(pacman -Qdtq)’
    alias dbox=‘distrobox’
    source /usr/share/nvm/init-nvm.sh
    ;;

  kali|ubuntu)
    alias update='sudo apt update'
    alias upgrade='sudo apt upgrade -y'
    alias install='sudo apt install'
    alias remove=‘sudo apt purge’
    alias clean=‘sudo apt autoremove && sudo apt autoclean && sudo apt clean’
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    # Variables for auto-install checks
    UV_LOCATION="${HOME}/.local/bin/uv"
    NVM_HOME="${HOME}/.nvm"

    [[ -f "$UV_LOCATION" ]] || curl -LsSf https://astral.sh/uv/install.sh | sh
    [[ -d "$NVM_HOME" ]] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    export PATH="$PATH:$NVIM_LOCATION"


    if [[ "$os_id" == "ubuntu" ]]; then
        NVIM_LOCATION="/opt/nvim-linux-x86_64/bin"
        if [[ ! -d "$NVIM_LOCATION" ]]; then
          curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
          sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        fi
        export NVM_DIR="$HOME/.config/nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        export PATH="$PATH:$NVIM_LOCATION"
    fi
    ;;
esac

# --- Integrations & Paths ---
command -v fzf >/dev/null && source <(fzf --zsh)
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

export GOPATH=$HOME/.go
if [[ "$os_id" == "macos" ]]; then
    export PATH=$PATH:$GOPATH/bin
else
    export GOROOT=/usr/lib/go
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi

export PATH=$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin:$PATH
