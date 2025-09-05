# --- Powerlevel10k instant prompt ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Plugin Directories ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
TMUX_PLUGIN_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/tmux/plugins/tpm"

# --- Ensure Plugins are Installed ---
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
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# --- Completions ---
autoload -Uz compinit && compinit
zinit cdreplay -q

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
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
  hist_save_no_dups hist_ignore_dups hist_find_no_dups

# --- Completion Styling ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --- Aliases ---
alias ls='ls --color'
alias ll='ls -la --color'
alias vim='nvim'
alias vi='nvim'
alias c='clear'
alias nano='nano -lmq'
alias tarc='tar -cvzf'
alias tard='tar -xvzf'
alias lzg='lazygit'
alias lzd='lazydocker'
alias venv='source .venv/bin/activate'

# --- OS-specific Aliases and Installs ---
os_id=$(awk -F= '$1=="ID"{print $2}' /etc/os-release)

case "$os_id" in
  manjaro)
    alias update='sudo pacman -Syu'
    alias install='sudo pacman -S'
    alias remove='sudo pacman -Rcns'
    alias clean='sudo pacman -R $(pacman -Qdtq)'
    alias dbox='distrobox'
    ;;
  kali|ubuntu)
    alias update='sudo apt update'
    alias upgrade='sudo apt upgrade -y'
    alias install='sudo apt install'
    alias remove='sudo apt purge'
    alias aptclean='sudo apt autoremove && sudo apt autoclean && sudo apt clean'

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    if [[ "$os_id" == "kali" ]]; then
      if [[ "$(uname -m)" == "aarch64" ]]; then
        alias cs='code-server'
        alias vc='verdaccio'

        NVM_HOME="${HOME}/.nvm"
        UV_LOCATION="${HOME}/.local/bin/uv"
        NVIM_LOCATION="/opt/nvim-linux-arm64/bin"
        [[ -d "$NVM_HOME" ]] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        [[ -f "$UV_LOCATION" ]] || curl -LsSf https://astral.sh/uv/install.sh | sh
        if [[ ! -d "$NVIM_LOCATION" ]]; then
          curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
          sudo rm -rf /opt/nvim
          sudo tar -C /opt -xzf nvim-linux-arm64.tar.gz
        fi

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        export PATH="$PATH:/opt/nvim-linux-arm64/bin"
      fi

    elif [[ "$os_id" == "ubuntu" ]]; then
 
      FZF_HOME="${HOME}/.fzf"
      NVM_HOME="${HOME}/.config/nvm"
      UV_LOCATION="${HOME}/.local/bin/uv"
      NVIM_LOCATION="/opt/nvim-linux-x86_64/bin"
      [[ -d "$FZF_HOME" ]] || { git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all; }
      [[ -d "$NVM_HOME" ]] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
      [[ -f "$UV_LOCATION" ]] || curl -LsSf https://astral.sh/uv/install.sh | sh
      if [[ ! -d "$NVIM_LOCATION" ]]; then
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
      fi

      export NVM_DIR="$HOME/.config/nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
    fi
    ;;
  *)
    alias c='clear'
    ;;
esac

# --- Shell Integrations ---
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

PATH=~/.console-ninja/.bin:$PATH
