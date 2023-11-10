#!/bin/bash
# this file is only meant for making these dotfiles usable on gitpod.io

current_dir="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
echo "Installing dotfiles from: $current_dir"

#on gitpod, this repo will be checked out to /home/gitpod/.dotfiles

ln -sf "${current_dir}/.bashrc" "${HOME}/.bashrc"
ln -sf "${current_dir}/.profile" "${HOME}/.profile"

