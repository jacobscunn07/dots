#!/usr/bin/env bash
#
# Install dotfiles: brew packages from brew/Brewfile, then stow the configs.
# Safe to re-run; stow --restow makes symlinking idempotent.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_ROOT/brew/Brewfile"
PACKAGES=(alacritty git lf nvim starship zellij zsh)

# Only install what's missing. Upgrading by default makes a re-run pull down large
# cask updates and stop on a sudo prompt; pass --upgrade when you actually want that.
BUNDLE_ARGS=(--no-upgrade)
if [[ "${1:-}" == "--upgrade" ]]; then
  BUNDLE_ARGS=(--upgrade)
fi

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# Homebrew installs to a different prefix on Apple Silicon vs Intel.
brew_prefix() {
  if [[ "$(uname -m)" == "arm64" ]]; then
    echo /opt/homebrew
  else
    echo /usr/local
  fi
}

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew not found, installing"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Put brew on PATH for the rest of this script, not just future shells.
  eval "$("$(brew_prefix)/bin/brew" shellenv)"
fi

[[ -f "$BREWFILE" ]] || die "no Brewfile at $BREWFILE"

log "Installing packages from $BREWFILE"
brew bundle --file="$BREWFILE" "${BUNDLE_ARGS[@]}"

command -v stow >/dev/null 2>&1 || die "stow not on PATH after brew bundle; is it in the Brewfile?"

# Create ~/.config first. Without it stow folds one level too high and links
# ~/.config itself into the repo, swallowing every other tool's config.
mkdir -p "$HOME/.config"

# Same hazard one level deeper: if ~/.config/git doesn't exist, stow folds it into a
# symlink to the repo and config.local (private identity) gets written inside the repo.
mkdir -p "$HOME/.config/git"

# .zshrc writes history and the completion dump into these; zsh won't create them itself.
mkdir -p "$HOME/.local/state/zsh" "$HOME/.cache/zsh"

for pkg in "${PACKAGES[@]}"; do
  log "Stowing $pkg"
  stow --dir="$REPO_ROOT" --target="$HOME" --restow --verbose=1 "$pkg"
done

# Identity is deliberately absent from the tracked config so this repo can be shared.
# The tracked config sets user.useConfigOnly, so git refuses to commit until this exists.
bootstrap_git_identity() {
  local local_config="$HOME/.config/git/config.local"
  local example="$HOME/.config/git/config.local.example"
  [[ -f "$local_config" ]] && return 0

  # May already come from elsewhere: a leftover ~/.gitconfig, or /etc/gitconfig.
  if git config --get user.email >/dev/null 2>&1; then return 0; fi

  # `read` fails at EOF, which would abort the script under `set -e`.
  if [[ ! -t 0 ]]; then
    log "No git identity set. Run: cp $example $local_config  (then edit it)"
    return 0
  fi

  log "Git identity not configured"
  local name email
  if ! read -r -p "  Name:  " name || ! read -r -p "  Email: " email; then
    log "No input received. Run: cp $example $local_config  (then edit it)"
    return 0
  fi
  [[ -n "$name" ]] || die "name is required"
  [[ "$email" == *@* ]] || die "email must contain @"

  cat > "$local_config" <<EOF
# Machine-local git identity. Not tracked by the dotfiles repo.
[user]
    name = $name
    email = $email

# See config.local.example beside this file for other things that can go here.
EOF
  log "Wrote $local_config"
}

bootstrap_git_identity

log "Done"
