#!/usr/bin/env bash
#
# update-all.sh — keep developer tooling on this Mac up to date.
# Safe to re-run anytime. Skips steps for tools that aren't installed.

set -uo pipefail

bold() { printf "\n\033[1m== %s ==\033[0m\n" "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

bold "macOS security & system updates"
softwareupdate -l 2>&1 | tail -n +1 || true
echo "(Run 'sudo softwareupdate -ia' to install any listed above.)"

if have brew; then
  bold "Homebrew: update, upgrade, cleanup"
  brew update
  brew upgrade
  brew cleanup
  brew autoremove
  echo "Remaining outdated (casks like Docker may self-update):"
  brew outdated --greedy || true
fi

if have rustup; then
  bold "Rust: rustup + toolchains"
  rustup self update || true
  rustup update
fi

if have mise; then
  bold "mise: runtimes and npm: tools"
  mise upgrade
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
  bold "Oh My Zsh + custom plugins"
  zsh "$HOME/.oh-my-zsh/tools/upgrade.sh" || true
  for plugin in "$HOME"/.oh-my-zsh/custom/plugins/*/.git; do
    [ -d "$plugin" ] || continue
    dir="${plugin%/.git}"
    echo "${dir##*/}"
    git -C "$dir" pull --ff-only --quiet || true
  done
fi

if have brew; then
  bold "Homebrew health check"
  brew doctor || true
fi

bold "Done"
echo "Tip: Docker Desktop and other auto-updating apps update themselves on launch."
