# ~/.config/zsh/.zshenv

# ---------- XDG base directories ----------
# Centralizes config/cache/data locations
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ---------- Editor ----------
# Default editor used by git, crontab, etc.
export EDITOR="nvim"
export VISUAL="nvim"

# ---------- Pager ----------
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# Drives bat itself, the fzf preview pane, MANPAGER above, and git diffs (delta uses bat
# for syntax highlighting). Without this bat falls back to Monokai Extended.
export BAT_THEME="gruvbox-dark"

# ---------- GPG ----------
export GPG_TTY=$(tty)

# ---------- Starship ----------
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# ---------- PATH ----------
# Personal binaries/scripts
export PATH="$HOME/.local/bin:$PATH"
