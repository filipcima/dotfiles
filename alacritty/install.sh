#!/usr/bin/env bash

echo "Installing alacritty..."

# Symlink alacrity config
mkdir -p ~/.config/alacritty/
ln -sf ~/.dotfiles/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml