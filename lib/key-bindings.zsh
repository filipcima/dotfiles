# ------------------------------------------------------------------------------
#                                    OMZ Lib
# ------------------------------------------------------------------------------
# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e                                            # Use emacs key bindings
bindkey -s "\el" "ls -lhg\n"                          # [Esc-l] - run command: ls
bindkey " " magic-space                               # [Space] - do history expansion [write command with ! at the start and press enter]

# ------------------------------------------------------------------------------
#                                     Custom
# ------------------------------------------------------------------------------
# See https://stackoverflow.com/questions/6205157/iterm-2-how-to-set-keyboard-shortcuts-to-jump-to-beginning-end-of-line/29403520#29403520
# bindkey -e # Already defined above

# changes hex 0x15 to delete everything to the left of the cursor,
# rather than the whole line
bindkey "^U" backward-kill-line

# binds hex 0x18 0x7f with deleting everything to the left of the cursor
bindkey "^X\\x7f" backward-kill-line

# adds redo
bindkey "^X^_" redo