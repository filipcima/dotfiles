#!/usr/bin/env bash

echo "Installing mackup custom sync configs..."

# Symlink mackup cfg
ln -sf ~/.dotfiles/.mackup.cfg ~/.mackup.cfg

# Symlink custom configs dir
rm -rf ~/.dotfiles/mackup/mackup
rm -rf ~/.mackup
ln -s ~/.dotfiles/mackup ~/.mackup