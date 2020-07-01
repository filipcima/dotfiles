## Installation

Dotfiles are installed by running one of the following commands in your terminal, just copy one of the following commands and execute in the terminal:

**via `curl`**

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jsimck/dotfiles/master/install.sh)"
```

**via `wget`**

```sh
bash -c "$(wget https://raw.githubusercontent.com/jsimck/dotfiles/master/install.sh -O -)"
```

Tell Git who you are using these commands:

```
git config -f ~/.gitlocal user.email "email@yoursite.com"
git config -f ~/.gitlocal user.name "Name Lastname"
```

## Updating

Use single command to get latest updates:

```
update
```

This command will update dotfiles, their dependencies, `brew` packages, global `npm` dependencies, `gem`s, `apm` plugins.

## References
 - [https://github.com/driesvints/dotfiles](https://github.com/driesvints/dotfiles)
 - [https://github.com/denysdovhan/dotfiles](https://github.com/denysdovhan/dotfiles)
