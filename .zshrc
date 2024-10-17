# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "hlissner/zsh-autopair"
plug "zap-zsh/sudo"
plug "MAHcodes/distro-prompt"
plug "kutsan/zsh-system-clipboard"
plug "MichaelAquilina/zsh-you-should-use"

# Load and initialise completion system
autoload -Uz compinit
compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
  fi

else
  alias c='clear'
fi

# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
