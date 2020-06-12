#!/usr/bin/env zsh

# Get System Updates, update NPM packages and dotfiles
# Source: https://github.com/sapegin/dotfiles/blob/master/setup/update.sh

trap on_error SIGKILL SIGTERM

e='\033'
RESET="${e}[0m"
BOLD="${e}[1m"
CYAN="${e}[0;96m"
RED="${e}[0;91m"
YELLOW="${e}[0;93m"
GREEN="${e}[0;92m"

_exists() {
  command -v $1 > /dev/null 2>&1
}

info() {
  echo -e "${CYAN}${*}${RESET}"
}

error() {
  echo -e "${RED}${*}${RESET}"
}

success() {
  echo -e "${GREEN}${*}${RESET}"
}

finish() {
  success "Done!"
  echo
  sleep 1
}

export DOTFILES=${1:-"$HOME/.dotfiles"}

on_start() {
  info "                      _       _    __ _ _            "
  info "                   __| | ___ | |_ / _(_) | ___  ___  "
  info "                  / _| |/ _ \| __| |_| | |/ _ \/ __| "
  info "                 | (_| | (_) | |_|  _| | |  __/\__ \ "
  info "                (_)____|\___/ \__|_| |_|_|\___||___/ "
  info "                                                     "
  info "                           by Jan Šimeček            "
  info "                                                     "
}

update_dotfiles() {
  info "Updating dotfiles..."

  cd $DOTFILES
  git pull --rebase origin master

  info "Updating zplug packages..."

  # Remove repositories which are no longer managed
  zplug clean --force
  # Remove the cache file
  zplug clear
  # Update installed packages in parallel
  zplug update
  zplug install

  info "Running updaters..."
  # Run updaters
  for file in $DOTFILES/*/update.sh
    do
    bash "$file"
  done
  
  finish
}

update_brew() {
  if ! _exists brew; then
    return
  fi

  info "Updating Homebrew..."

  brew update
  brew upgrade
  brew bundle --file=$DOTFILES/Brewfile
  brew bundle cleanup
  brew cleanup

  finish
}

update_npm() {
  if ! _exists npm; then
    return
  fi

  info "Updating NPM..."

  NPM_PERMS="$(ls -l $(npm config get prefix)/bin \
    | awk 'NR>1{print $3}' \
    | grep "$(whoami)" \
    | uniq)"

  if [[ "$NPM_PERMS" == "$(whoami)" ]]; then
    info "Permissions are fixed. Updating without sudo..."
    npm install npm -g
  else
    error "Permissions needed!"
    echo "Better to fix your permissions. Read more:"
    echo "\t <https://docs.npmjs.com/getting-started/fixing-npm-permissions>"
    echo
    echo "The script will ask you the password for sudo:"
    sudo npm install npm -g
  fi

  # Update packages with npm-check-updates
  if _exists npx; then
    npx ncu -g
  else
    npm install ncu -g
    npx ncu -g
  fi

  finish
}

update_gem() {
  if ! _exists gem; then
    return
  fi

  info "Updating Ruby gems..."

  sudo -v
  sudo gem update

  finish
}

on_finish() {
  success "Done!"
  success "Happy Coding!"
  echo
  echo -ne $RED'-_-_-_-_-_-_-_-_-_-_-_-_-_-_'
  echo -e  $RESET$BOLD',------,'$RESET
  echo -ne $YELLOW'-_-_-_-_-_-_-_-_-_-_-_-_-_-_'
  echo -e  $RESET$BOLD'|   /\_/\\'$RESET
  echo -ne $GREEN'-_-_-_-_-_-_-_-_-_-_-_-_-_-'
  echo -e  $RESET$BOLD'~|__( ^ .^)'$RESET
  echo -ne $CYAN'-_-_-_-_-_-_-_-_-_-_-_-_-_-_'
  echo -e  $RESET$BOLD'""  ""'$RESET
  echo
}

on_error() {
  error "Wow... Something serious happened!"
  error "Though, I don't know what really happened :("
  exit 1
}

main() {
  on_start "$*"
  update_dotfiles "$*"
  update_brew "$*"
  update_npm "$*"
  update_gem "$*"
  on_finish "$*"
}

main "$*"