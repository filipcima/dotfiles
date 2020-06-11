#!/usr/bin/env bash

echo "Installing tmux..."

# Install oh-my-tmux
git clone https://github.com/gpakosz/.tmux.git ~/.oh-my-tmux
ln -sf ~/.oh-my-tmux/.tmux.conf ~/
ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf.local

# Install tmp
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm