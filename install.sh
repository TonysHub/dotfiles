#!/usr/bin/env zsh


# Brew dependencies
BREW_DEPENDENCIES=(
  fd
  ripgrep
  wget
  gcc
  gzip
  gnu-tar
  gnu-sed
  git
  curl
  lazygit
  tmux
  neovim
  stow
  tmuxinator
  pinentry-mac
)

# Install Homebrew dependencies
echo "Installing Homebrew dependencies..."
for package in $BREW_DEPENDENCIES; do
  if ! brew list $package &>/dev/null; then
    echo "Installing $package..."
    brew install $package
  else
    echo "$package is already installed."
  fi
done

DOTFILES=$HOME/dotfiles
BACKUP_DIR=$HOME/.dotfiles_old

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

# List of files and folders to back up
FILES_TO_BACKUP=(
  ".config/nvim"
  ".config/tmuxinator"
  ".tmux.conf"
  ".zshrc"
)

# Stow folders
STOW_FOLDERS="nvim,tmux,zsh,tmuxinator"

# Back up existing files and folders
echo "Backing up existing dotfiles..."
for item in "${FILES_TO_BACKUP[@]}"; do
  if [[ -e $HOME/$item ]]; then
    echo "Backing up $item to $BACKUP_DIR"
    mv $HOME/$item $BACKUP_DIR/
  fi
done


# Ensure DOTFILES directory exists
if [[ ! -d $DOTFILES ]]; then
  echo "Error: DOTFILES directory $DOTFILES does not exist!"
  exit 1
fi

# Symlink dotfiles using GNU Stow
echo "Symlinking dotfiles with GNU Stow..."
pushd $DOTFILES >/dev/null
for folder in nvim tmux zsh tmuxinator; do
  echo "Processing $folder..."
  stow -D $folder  # Remove existing symlinks
  stow $folder     # Create new symlinks
done
popd >/dev/null
