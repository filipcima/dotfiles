# Path to dotfiles.
export DOTFILES=$HOME/.dotfiles

# ------------------------------------------------------------------------------
#                                Environment
# ------------------------------------------------------------------------------

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Extend $PATH without duplicates
_extend_path() {
  if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$1" ) ; then
    export PATH="$1:$PATH"
  fi
}

# Extend Path
[[ -d "$HOME/.bin" ]] && _extend_path "$(brew --prefix coreutils)/libexec/gnubin"
[[ -d "$HOME/.local" ]] && _extend_path ~/.local/bin
[[ -d "$DOTFILES/bin" ]] && _extend_path ~/.dotfiles/bin

# Defaults
export PAGER='less'

# less options
less_opts=(
  # Quit if entire file fits on first screen.
  --quit-if-one-screen
  # Ignore case in searches that do not contain uppercase.
  --ignore-case
  # Allow ANSI colour escapes, but no other escapes.
  --RAW-CONTROL-CHARS
  # Quiet the terminal bell. (when trying to scroll past the end of the buffer)
  --quiet
  # Do not complain when we are on a dumb terminal.
  --dumb
)
export LESS="${less_opts[*]}"

# Default editor for local and remote sessions
if [[ -n "$SSH_CONNECTION" ]]; then
  # on the server
  if [ command -v vim >/dev/null 2>&1 ]; then
    export EDITOR='vim'
  else
    export EDITOR='vi'
  fi
else
  export EDITOR='vim'
fi

# ------------------------------------------------------------------------------
#                                Zplug
# ------------------------------------------------------------------------------

# Source zplug plugin manager
source /usr/local/opt/zplug/init.zsh

# Let zplug manage itself like other packages
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# oh-my-zsh
zplug 'plugins/alias-finder', from:oh-my-zsh
zplug 'plugins/colored-man-pages', from:oh-my-zsh
zplug 'plugins/last-working-dir', from:oh-my-zsh
zplug 'plugins/zsh-interactive-cd', from:oh-my-zsh
zplug 'plugins/sudo', from:oh-my-zsh

# prezto [THE ORDER MATTERS]
zplug 'modules/archive',       from:prezto, lazy:true
zplug 'modules/osx',  from:prezto, lazy:true
zplug 'modules/utility',    from:prezto
zplug 'modules/spectrum', from:prezto, lazy:true
zplug 'modules/command-not-found',       from:prezto
zplug 'modules/editor', from:prezto, lazy:true
zplug 'modules/directory',  from:prezto
zplug 'modules/environment',       from:prezto
zplug 'modules/history',    from:prezto
zplug 'modules/node',       from:prezto, lazy:true
zplug 'modules/ssh',        from:prezto
zplug 'modules/brew',        from:prezto
zplug 'modules/syntax-highlighting', from:prezto
zplug 'modules/history-substring-search', from:prezto
zplug 'modules/autosuggestions', from:prezto
zplug 'modules/completion', from:prezto

# pretzo configuration
zstyle ':prezto:module:python:virtualenv' auto-switch 'yes'
zstyle ':prezto:module:tmux:auto-start' local 'yes'

zstyle ':prezto:module:syntax-highlighting' color 'yes'
zstyle ':prezto:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'line' \
  'root'

# Others
zplug "djui/alias-tips", from:github, defer:3
zplug "Seinh/git-prune", from:github
zplug "b4b4r07/enhancd", use:init.sh
zplug "hlissner/zsh-autopair", defer:2
zplug "rauchg/wifi-password", as:command, use:"wifi-password.sh", rename-to:"wifi-password", lazy:true

# Nvm
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
zplug "lukechilds/zsh-nvm"
zplug "lukechilds/zsh-better-npm-completion", defer:2

# Dotfiles
zplug "$DOTFILES/lib/*", from:local

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

# ------------------------------------------------------------------------------
#                        Other initializations
# ------------------------------------------------------------------------------

# Starship Theme
eval "$(starship init zsh)"

# Jump 
eval "$(jump shell)"

# ------------------------------------------------------------------------------
#                              Settings
# ------------------------------------------------------------------------------

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
ENHANCD_DISABLE_HOME='1'
ENHANCD_DISABLE_DOT='1'