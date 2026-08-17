#!/usr/bin/env bash
#
# Install dotfiles: brew packages from brew/Brewfile, then stow the configs.
# Safe to re-run; stow --restow makes symlinking idempotent.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_ROOT/brew/Brewfile"
PACKAGES=(alacritty zellij)

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

for pkg in "${PACKAGES[@]}"; do
  log "Stowing $pkg"
  stow --dir="$REPO_ROOT" --target="$HOME" --restow --verbose=1 "$pkg"
done

log "Done"
