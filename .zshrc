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

# --- Completions Initialization ---
# Best practice: Run compinit before loading complex completion plugins
autoload -Uz compinit && compinit

# --- Plugin Directories ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
TMUX_PLUGIN_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/tmux/plugins/tpm"

# --- Ensure Zinit and TPM are Installed ---
[[ -d "$ZINIT_HOME" ]] || { mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; }
[[ -d "$TMUX_PLUGIN_DIR" ]] || { mkdir -p "$TMUX_PLUGIN_DIR" && git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR"; }

# --- Zinit and Plugins ---
source "${ZINIT_HOME}/zinit.zsh"
zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light hlissner/zsh-autopair
zinit light kutsan/zsh-system-clipboard
zinit light MichaelAquilina/zsh-you-should-use
zinit light zsh-users/zsh-syntax-highlighting
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo

if [[ "$os_id" != "macos" ]]; then
  [[ "$os_id" == "manjaro" || "$os_id" == "cachyos" ]] && zinit snippet OMZP::archlinux
  [[ "$os_id" == "fedora" ]] && zinit snippet OMZP::dnf
  zinit snippet OMZP::command-not-found
fi

zinit cdreplay -q

# --- Completion Styling ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
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
  alias cpufreq='watch -n 1 sudo cpupower -c all frequency-info --freq -m'
  alias drop-cache='sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches'
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
  alias remove='brew uninstall'
  alias clean='brew cleanup'
  # Faster Colima Management
  alias d='docker'
  alias dc='docker-compose'
  alias cstart='colima start --vm-type vz --mount-type virtiofs --vz-rosetta'
  alias cstop='colima stop'
  # Ensure tools can find the Docker socket
  export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
  export CPPFLAGS="-I/opt/homebrew/opt/openjdk@21/include"
  ;;

manjaro | cachyos)
  alias update='sudo pacman -Syu'
  alias install='sudo pacman -S'
  alias remove='sudo pacman -Rcns'
  alias clean='sudo pacman -R $(pacman -Qdtq)'
  alias dbox='distrobox'
  source /usr/share/nvm/init-nvm.sh
  ;;

fedora)
  alias update='sudo dnf upgrade --refresh'
  alias install='sudo dnf install'
  alias remove='sudo dnf remove'
  alias clean='sudo dnf autoremove'
  alias dbox='distrobox'
  alias update-grub='sudo grub2-mkconfig -o /boot/grub2/grub.cfg'
  alias update-initramfs='sudo dracut --regenerate-all --force -v'
  alias flatup='flatpak update && flatpak uninstall --unused'

  # Set up NVM if manually installed via curl/git, otherwise handle default path
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  ;;

kali | ubuntu)
  alias update='sudo apt update'
  alias upgrade='sudo apt upgrade -y'
  alias install='sudo apt install'
  alias remove='sudo apt purge'
  alias clean='sudo apt autoremove && sudo apt autoclean && sudo apt clean'
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  UV_LOCATION="${HOME}/.local/bin/uv"
  NVM_HOME="${HOME}/.nvm"

  [[ -f "$UV_LOCATION" ]] || curl -LsSf https://astral.sh/uv/install.sh | sh
  [[ -d "$NVM_HOME" ]] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if [[ "$os_id" == "ubuntu" ]]; then
    NVIM_LOCATION="/opt/nvim-linux-x86_64/bin"
    if [[ ! -d "$NVIM_LOCATION" ]]; then
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
      sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    fi
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
  # Linux specific Go resolution path fallback
  [[ -d "/usr/lib/go" ]] && export GOROOT=/usr/lib/go
  [[ -d "/usr/lib64/golang" ]] && export GOROOT=/usr/lib64/golang # Fedora specific location
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi

export PATH=$HOME/.local/bin:$HOME/.npm-global/bin:$PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# NVMe/Disk TBW stats
nvme_stats() {
  if [ "$(uname)" = "Darwin" ]; then
    sudo smartctl -a /dev/disk0 | grep -i "Data Units Written"
  elif [ "$(uname)" = "Linux" ]; then
    local drive
    drive=$(lsblk -dno NAME | grep -m1 nvme)
    if [ -n "$drive" ]; then
      sudo smartctl -a "/dev/$drive" | grep -i "Data Units Written"
    else
      echo "Error: No NVMe drive found via lsblk." >&2
      return 1
    fi
  else
    echo "Error: Unsupported OS." >&2
    return 1
  fi
}

# Firmware updates via fwupdmgr
fw_update() {
  echo "=== [1/3] Refreshing firmware metadata ==="
  if ! sudo fwupdmgr refresh --force; then
    echo "Error: Failed to refresh metadata from Linux Vendor Firmware Service." >&2
    return 1
  fi

  echo -e "\n=== [2/3] Checking for available updates ==="
  if ! fwupdmgr get-updates; then
    # fwupdmgr returns non-zero/error codes if no updates are available
    echo "No firmware updates available at this time."
    return 0
  fi

  echo -e "\n=== [3/3] Executing firmware upgrade ==="
  # --assume-yes passes confirmations, but fwupdmgr will still prompt if a reboot is needed
  sudo fwupdmgr upgrade --assume-yes
}
