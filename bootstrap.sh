#!/bin/bash

set -ex

function install_packages {
  sudo apt-get update
  for pkg in "${@}"
  do
    if ! dpkg -s "$pkg" | grep "installed"; then
      sudo apt-get install -y "$pkg"
    fi
  done
}

install_packages jq tree mosh zsh

locale-gen en_CA.UTF-8

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

zsh_plugins="$HOME/.oh-my-zsh/custom/plugins"
autosuggestions="$zsh_plugins/zsh-autosuggestions"
syntax_highlighting="$zsh_plugins/zsh-syntax-highlighting"

if [ ! -d "$autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$autosuggestions"
fi

if [ ! -d "$syntax_highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$syntax_highlighting"
fi

if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
  "$HOME"/.fzf/install
fi
