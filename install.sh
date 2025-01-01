#!/usr/bin/env zsh

# Set the DOTFILES directory
DOTFILES=$HOME/dotfiles

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
)

# Stow folders
STOW_FOLDERS="nvim,tmux,zsh,git,tmuxinator"

# Back up existing files/folders
backup_existing() {
  local target=$1
  if [[ -e $target || -L $target ]]; then
    local backup="${target}_old_$(date +%Y%m%d%H%M%S)"
    echo "Backing up $target to $backup"
    mv "$target" "$backup"
  fi
}

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

# Ensure DOTFILES directory exists
if [[ ! -d $DOTFILES ]]; then
  echo "Error: DOTFILES directory $DOTFILES does not exist!"
  exit 1
fi

# Symlink dotfiles using GNU Stow
echo "Symlinking dotfiles with GNU Stow..."
pushd $DOTFILES >/dev/null
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g"); do
  echo "Processing $folder..."
  for file in $(stow --no --verbose=2 $folder 2>&1 | grep -o "WARNING! .* already exists" | awk '{print $2}'); do
    backup_existing "$HOME/$file"
  done
  stow -D $folder  # Remove any existing symlinks
  stow $folder     # Create new symlinks
done
popd >/dev/null
