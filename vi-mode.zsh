#!/usr/bin/env zsh

# Enable vi mode
bindkey -v

# Prevent the delay when switching mode
KEYTIMEOUT=5

# Print DCS characters around an escape sequence
function print_dcs {
  print -n -- "\EP$1;\E$2\E\\"
}

function set_cursor_shape {
  if [ -n "$TMUX" ]; then
    # tmux will only forward escape sequences to the terminal if surrounded by
    # a DCS sequence
    print_dcs tmux "\E]50;CursorShape=$1\C-G"
  else
    print -n -- "\E]50;CursorShape=$1\C-G"
  fi
}

# Switch cursor based on current mode
function zle-keymap-select zle-line-init {
  case $KEYMAP in
    vicmd)
      set_cursor_shape 0 # block cursor
      ;;
    *)
      set_cursor_shape 1 # line cursor
      ;;
  esac
  zle reset-prompt
  zle -R
}

function zle-line-finish
{
  set_cursor_shape 1 # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
