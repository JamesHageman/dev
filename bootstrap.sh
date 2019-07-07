#!/bin/bash

set -ex

script_path=$(dirname "$(realpath "$0")")

function retry_times {
  retries=$1
  command=$2
  delay=5

  n=0
  while [ $n -le "$retries" ]; do
    if $command; then
      break
    fi

    n=$((n + 1))
    if [ $n -eq "$retries" ]; then
      echo "($n/$retries) command '$command' failed."
      return 1
    else
      echo "($n/$retries) command '$command' failed. Retrying in ${delay}s"
      sleep $delay
    fi
  done
}

function install_packages {
  retry_times 5 "apt-get update"
  for pkg in "${@}"
  do
    if ! dpkg -s "$pkg" | grep "installed"; then
      retry_times 5 "apt-get install -y $pkg"
    fi
  done
}

install_packages jq tree mosh zsh

if [ ! -f /etc/locale.gen ] || ! grep -q "^en_CA\.UTF-8" /etc/locale.gen ; then
  locale-gen en_CA.UTF-8
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
  chmod +x install.sh
  cat install.sh
  echo "y" | RUNZSH=no CHSH=yes ./install.sh
  rm -f install.sh
  rm -f ~/.zshrc
fi

ln -sf "$script_path"/.zshrc "$HOME/.zshrc"

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
  "$HOME"/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi
