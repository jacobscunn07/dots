# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# =========================================================
# Before compinit
# =========================================================
# Anything that adds to $fpath or registers completions. zinit shims compdef
# and records these calls for cdreplay below.

zinit light zsh-users/zsh-completions

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# =========================================================
# compinit
# =========================================================
# The one and only call. -d keeps the dump in the cache; without it zsh writes
# $ZDOTDIR/.zcompdump, and $ZDOTDIR is a symlink into the dotfiles repo.

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Replay the compdef calls made above, before compinit existed
zinit cdreplay -q

# =========================================================
# After compinit
# =========================================================
# fzf-tab must follow compinit and precede anything that wraps ZLE widgets.
# zsh-syntax-highlighting must be last.

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
