#!/usr/bin/env bash

echo "Installing git..."

# Symlink configs
ln -sf $HOME/.dotfiles/git/.gitconfig $HOME
ln -sf $HOME/.dotfiles/git/.gitignore $HOME
cp -n $HOME/.dotfiles/git/.gitconfig.local $HOME
cp -n $HOME/.dotfiles/git/.gitconfig.projects $HOME
cp -n $HOME/.dotfiles/git/.gitconfig.workspace $HOME
