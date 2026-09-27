#!/usr/bin/env bash
#
# update-all.sh — keep developer tooling on this Mac up to date and secure.
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

if have npm; then
  bold "npm: self-update + outdated globals"
  npm install -g npm@latest
  echo "Outdated global packages:"
  npm outdated -g || true
fi

if have brew; then
  bold "Security audit (Homebrew)"
  brew doctor || true
fi

bold "Done"
echo "Tip: Docker Desktop and other auto-updating apps update themselves on launch."
