# ------------------------------------------------------------------------------
#                                Overrides & Fixes
# ------------------------------------------------------------------------------
alias cd='__enhancd::cd'
alias ls='exa'

# ------------------------------------------------------------------------------
#                                     General
# ------------------------------------------------------------------------------

# Shortcuts
alias zshrc='${=EDITOR} ~/.zshrc' # Quick access to the ~/.zshrc file
alias update='source $DOTFILES/update.zsh'
alias copyssh='pbcopy < $HOME/.ssh/id_rsa.pub'
alias reloadshell='source $HOME/.zshrc'
alias flushdns='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
alias c='clear'

# Directory Shortcuts
alias home='j ~/'
alias dot='j $DOTFILES'
alias lib='cd $HOME/Library'
alias work='j workspace'
alias proj='j projects'

# JS
alias nfresh='rm -rf node_modules/ package-lock.json && npm install'

# Directories & Files
alias rd=rmdir
alias l='exa --long --header --git'
alias la='exa --all --long --header --git'
alias t='tail -f'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| rg -p'
alias -g L='| less'
alias -g M='| most'
alias -g LL='2>&1 | less'
alias -g CA='2>&1 | cat -A'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hrg='fc -El 0 | rg -p'
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'

alias rm='rm'
alias cp='cp'
alias mv='mv'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'

# ------------------------------------------------------------------------------
#                                       Git
# ------------------------------------------------------------------------------

alias g='git'

# This will load all aliases from git config prefixed with g
for al in `git --list-cmds=alias`; do
  alias g$al="git $al"
done
