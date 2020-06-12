#!/usr/bin/env bash

echo "Updating tmux..."

# Update oh-my-tmux
( cd ~/.oh-my-tmux ; git pull )

# Update tmp
( cd ~/.tmux/plugins/tpm ; git pull )