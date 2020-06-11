#!/usr/bin/env bash

echo "Installing mackup custom sync configs..."

# Symlink mackup cfg
ln -sf ~/.dotfiles/.mackup.cfg ~/.mackup.cfg

# Symlink custom configs dir
ln -sf ~/.dotfiles/mackup ~/.mackup
