#!/bin/bash

# Header logging
e_header() {
  printf "\n$(tput setaf 7)%s$(tput sgr0)\n" "$@"
}

# Success logging
e_success() {
  printf "$(tput setaf 64)✓ %s$(tput sgr0)\n" "$@"
}

# Error logging
e_error() {
  printf "$(tput setaf 1)x %s$(tput sgr0)\n" "$@"
}

# Warning logging
e_warning() {
  printf "$(tput setaf 136)! %s$(tput sgr0)\n" "$@"
}

# Ask for confirmation before proceeding
seek_confirmation() {
  printf "\n"
  e_warning "$@"
  read -p "Continue? (y/n) " -n 1
  printf "\n"
}

# Test whether the result of an 'ask' is a confirmation
is_confirmed() {
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

# Test whether we're in a git repo
is_git_repo() {
  $(git rev-parse --is-inside-work-tree &> /dev/null)
}

# Test whether a command exists
# $1 - cmd to test
command_exists() {
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

# Test whether a directory exists
# $1 - directory to test
directory_exists() {
  if [[ -d "$1" ]]; then
    return 0
  fi
  return 1
}

# Test whether a file exists
# $1 - file to test
file_exists() {
  if [[ -f "$1" ]]; then
    return 0
  fi
  return 1
}

# Test whether a symlink exists
# $1 - file to test
link_exists() {
  if [[ -L "$1" ]]; then
    return 0
  fi
  return 1
}

# Test whether a Homebrew formula is already installed
# $1 - formula name (may include options)
formula_exists() {
  if $(brew list $1 >/dev/null); then
    printf "%s already installed.\n" "$1"
    return 0
  fi

  e_warning "Missing formula: $1"
  return 1
}