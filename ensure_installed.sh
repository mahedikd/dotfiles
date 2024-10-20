#!/bin/bash

ensure_packages() {
    local packages=("$@")
    local to_install=()
    local installed=()

    for pkg in "${packages[@]}"; do
        case $pkg in
            ripgrep)
                which rg &> /dev/null && installed+=("$pkg") || to_install+=("$pkg")
                ;;
            neovim)
                which nvim &> /dev/null && installed+=("$pkg") || to_install+=("$pkg")
                ;;
            python3-pip)
                python3 -m pip --version &> /dev/null && installed+=("$pkg") || to_install+=("$pkg")
                ;;
            python3-venv)
                python3 -m venv --help &> /dev/null && installed+=("$pkg") || to_install+=("$pkg")
                ;;
            *)
                which "$pkg" &> /dev/null && installed+=("$pkg") || to_install+=("$pkg")
                ;;
        esac
    done

    echo "Already installed: ${installed[*]}"

    if [ ${#to_install[@]} -ne 0 ]; then
        echo "Packages to install: ${to_install[*]}"
        echo "Installing now..."
        
        # Detect the package manager and install
        if which apt &> /dev/null; then
            sudo apt update && sudo apt install -y "${to_install[@]}"
        elif which dnf &> /dev/null; then
            sudo dnf install -y "${to_install[@]}"
        elif which pacman &> /dev/null; then
            sudo pacman -Syu --noconfirm "${to_install[@]}"
        elif which brew &> /dev/null; then
            brew install "${to_install[@]}"
        else
            echo "Unsupported package manager. Please install manually: ${to_install[*]}"
            return 1
        fi
    else
        echo "All specified packages are already installed."
    fi
}

# ensure_packages zoxide git curl docker wget btop 
ensure_packages zoxide git curl wget btop ripgrep fzf neovim nano tmux python3 python3-pip python3-venv nodejs npm fastfetch 
