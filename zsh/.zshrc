export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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

# Preserve Codex output in tmux scrollback for mouse scrolling and copy-mode.
if [[ -n "$TMUX" ]]; then
  alias codex='codex --no-alt-screen'
fi

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

# pnpm
export PNPM_HOME="/Users/tonylee/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/tonylee/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

unreleased_commits() {
  python3 "$HOME/.local/bin/unreleased_commits.py" "$@"
}
