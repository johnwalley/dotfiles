#!/usr/bin/env zsh
# install.sh — bootstrap this machine, then stow the dotfiles.
# Safe to re-run: every step is guarded and idempotent.
set -e

# 1. Homebrew
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Make brew available in this shell (covers Apple Silicon, Intel, Linux)
for p in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$p" ] && eval "$("$p" shellenv)" && break
done

# 2. Machine role (work/personal) — pass as an argument or answer the prompt
ROLE_FILE="$HOME/.config/dotfiles/role"
if [ -n "$1" ]; then
  role="$1"
elif [ -f "$ROLE_FILE" ]; then
  role="$(cat "$ROLE_FILE")"
else
  read "role?Machine role (work/personal): "
fi
case "$role" in
  work|personal) ;;
  *) echo "Unknown role: $role (expected work or personal)" >&2; exit 1 ;;
esac
mkdir -p "$(dirname "$ROLE_FILE")"
echo "$role" > "$ROLE_FILE"

# 3. Packages and apps (Brewfile reads the role)
brew bundle --file="$(dirname "$0")/Brewfile"

# 4. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. Custom Oh My Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-completions" ] || \
  git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

# 6. Symlink the dotfiles (run from the repo root)
cd "$(dirname "$0")"
stow -R .

echo "Done. Open a new terminal or run: exec zsh"
