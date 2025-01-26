# Use dynamic paths
export PATH="$HOME/.local/bin:$PATH"
export PYTHONPATH="$HOME/Library/Python/3.11/lib/python/site-packages"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

export EDITOR='vim'

# Source sensitive configurations
[ -f ~/.env ] && source ~/.env

# Aliases
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
alias manage="docker compose -f docker/docker-compose.dev.yml exec web python manage.py"
alias start="tmuxinator start"

# direnv
eval "$(direnv hook zsh)"

# Load fzf (if available)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Function to initialize MY_PYTHON_PATH with optional argument
python_dir_init() {
    local target_dir="${1:-$PWD}"  # Use argument if provided, otherwise current directory

    if [ -d "$target_dir/.venv" ]; then
        export MY_PYTHON_PATH="$target_dir/.venv/bin/python"
        echo "MY_PYTHON_PATH set to $MY_PYTHON_PATH"
    else
        unset MY_PYTHON_PATH
        echo "No .venv directory found in $target_dir. MY_PYTHON_PATH unset."
    fi
}
