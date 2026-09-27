# Homebrew in every shell (not just login shells), so fpath -- and the compinit dump -- stay stable
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
typeset -U path fpath

# Machine-specific environment (kept out of the repo)
[ -f "$HOME/.profile" ] && source "$HOME/.profile"

# Oh My Zsh (prompt is handled by starship below)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

command -v starship >/dev/null && eval "$(starship init zsh)"

# zsh-syntax-highlighting via Homebrew (prefix-agnostic: works on Intel, ARM, Linux)
if command -v brew >/dev/null; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
fi

# atuin (shell history)
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
command -v atuin >/dev/null && eval "$(atuin init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Vite+ bin (https://viteplus.dev)
# Appended rather than sourcing ~/.vite-plus/env, which prepends its node/npm/npx
# shims and would shadow mise. vp/vpx and global tools remain available.
case ":$PATH:" in
  *":$HOME/.vite-plus/bin:"*) ;;
  *) [ -d "$HOME/.vite-plus/bin" ] && export PATH="$PATH:$HOME/.vite-plus/bin" ;;
esac

# Rust (cargo)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ~/.local/bin (uv and other user-installed tools)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# LM Studio CLI (lms)
case ":$PATH:" in
  *":$HOME/.lmstudio/bin:"*) ;;
  *) [ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin" ;;
esac

# Personal scripts
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac

# mise (node and other runtimes; follows .nvmrc per directory). After the PATH
# edits above so its prompt hook keeps the active runtime first on PATH.
command -v mise >/dev/null && eval "$(mise activate zsh)"

# Role-specific config (work/personal), then untracked machine-local config
DOTFILES="${${:-$HOME/.zshrc}:A:h}"
DOTFILES_ROLE="$(cat "$HOME/.config/dotfiles/role" 2>/dev/null)"
[ -n "$DOTFILES_ROLE" ] && [ -f "$DOTFILES/zsh/$DOTFILES_ROLE.zsh" ] && source "$DOTFILES/zsh/$DOTFILES_ROLE.zsh"
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
