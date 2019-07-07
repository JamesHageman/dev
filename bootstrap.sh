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

install_packages jq mosh zsh

locale-gen en_CA.UTF-8

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
