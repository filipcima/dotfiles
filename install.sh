#!/usr/bin/env bash

# Dotfiles and bootstrap installer
# (Source: https://github.com/denysdovhan/dotfiles/blob/master/installer.sh)

# ------------------------------------------------------------------------------
#                                     Helpers
# ------------------------------------------------------------------------------

set -e
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

# Configs
export DOTFILES=${1:-"$HOME/.dotfiles"}
GITHUB_REPO_URL_BASE="https://github.com/jsimck/dotfiles.git"
HOMEBREW_INSTALLER_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"

on_start() {
  info "                      _       _    __ _ _            "
  info "                   __| | ___ | |_ / _(_) | ___  ___  "
  info "                  / _| |/ _ \| __| |_| | |/ _ \/ __| "
  info "                 | (_| | (_) | |_|  _| | |  __/\__ \ "
  info "                (_)____|\___/ \__|_| |_|_|\___||___/ "
  info "                                                     "
  info "                           by Jan Šimeček            "
  info "                                                     "

  info "This script will try to setup dotfiles and included configuration files."
  read -p "           Do you want to proceed with installation? [y/N] " -n 1 answer
  echo
  echo
  if [ ${answer} != "y" ]; then
    exit 1
  fi
}

# ------------------------------------------------------------------------------
#                               Separate installers
# ------------------------------------------------------------------------------

install_cli_tools() {
  info "Trying to detect installed Command Line Tools..."

  if ! [ $(xcode-select -p) ]; then
    echo "You don't have Command Line Tools installed!"
    info "Installing Command Line Tools..."
    echo "Please, wait until Command Line Tools will be installed, before continue."

    xcode-select --install
  else
    success "Seems like you have installed Command Line Tools. Skipping..."
  fi

  finish
}

install_homebrew() {
  info "Trying to detect installed Homebrew..."

  if ! _exists brew; then
    echo "Seems like you don't have Homebrew installed!"
    info "Installing Homebrew..."
    ruby -e "$(curl -fsSL ${HOMEBREW_INSTALLER_URL})"
    brew update
    brew upgrade
  else
    success "You already have Homebrew installed. Skipping..."
  fi

  finish
}

install_git() {
  info "Trying to detect installed Git..."

  if ! _exists git; then
    echo "Seems like you don't have Git installed!"
    info "Installing Git..."

    if [ `uname` == 'Darwin' ]; then
      brew install git
    else
      error "Error: Failed to install Git!"
      exit 1
    fi
  else
    success "You already have Git installed. Skipping..."
  fi

  finish
}

install_zsh() {
  info "Trying to detect installed Zsh..."

  if ! _exists zsh; then
    echo "Seems like you don't have Zsh installed!"
    info "Installing Zsh..."

    if [ `uname` == 'Darwin' ]; then
      brew install zsh
    else
      error "Error: Failed to install Zsh!"
      exit 1
    fi
  else
    success "You already have Zsh installed. Skipping..."
  fi

  finish

  if _exists zsh; then
    info "Setting up Zsh as default shell..."
    if [ $SHELL == "/usr/local/bin/zsh" ]; then
      success "You already have zsh as default shell. Skipping..."
    else
      echo "The script will ask you the password for sudo 2 times:"
      echo
      echo "1) When adding fish shell into /etc/shells via tee"
      echo "2) When changing your default shell via chsh -s"
      echo

      echo "$(command -v zsh)" | sudo tee -a /etc/shells
      chsh -s "$(command -v zsh)" || error "Error: Cannot set Zsh as default shell!"
    fi
  fi

  finish
}

install_dotfiles() {
  info "Trying to detect installed dotfiles in $DOTFILES..."

  if [ ! -d $DOTFILES ]; then
    echo "Seems like you don't have dotfiles installed!"
    info "Installing dotfiles..."

    git clone --recursive "$GITHUB_REPO_URL_BASE.git" $DOTFILES
  else
    success "You already have dotfiles installed. Skipping..."
  fi

  finish
}

bootstrap() {
  info "Bootstrapping environment..."

  # Ask for the administrator password upfront
  sudo -v
  
  echo "Installing brew dependencies..."

  # Update Homebrew recipes
  brew update
  
  # Install all our dependencies with bundle (See Brewfile)
  brew tap homebrew/bundle
  brew bundle || error "Some dependencies may have not installed correctly, but we will continue anyway..."
  
  echo "Creating Projects and Workspace directories..."

  # Create a Workspace and Projects directory
  mkdir -p $HOME/Workspace
  mkdir -p $HOME/Projects

  echo "Linking ZSH config..."
  
  # Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
  rm -rf $HOME/.zshrc
  ln -sf $HOME/.dotfiles/.zshrc $HOME/.zshrc
  
  echo "Running installers..."

  # Run installers
  for file in $HOME/.dotfiles/*/install.sh
    do
    bash "$file" || > /dev/null
  done

  finish
}

macos() {
  info "Setting MacOS defaults..."

  # Set macOS preferences
  # We will run this last because this will reload the shell
  source .macos || > /dev/null

  finish
}

on_finish() {
  echo
  success "Setup was successfully done!"
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
  info "P.S: Don't forget to restart a terminal and run your MACKUP (either restore or backup in case of new installation)"
  echo
}

on_error() {
  echo
  error "Wow... Something serious happened!"
  error "Though, I don't know what really happened :("
  error "In case, you want to help me fix this problem, raise an issue -> ${CYAN}${GITHUB_REPO_URL_BASE}issues/new${RESET}"
  echo
  exit 1
}

# ------------------------------------------------------------------------------
#                                     Main
# ------------------------------------------------------------------------------

main() {
  on_start "$*"
  install_cli_tools "$*"
  install_homebrew "$*"
  install_git "$*"
  install_zsh "$*"
  install_dotfiles "$*"
  bootstrap "$*"
  macos "$*"
  on_finish "$*"
}

main "$*"