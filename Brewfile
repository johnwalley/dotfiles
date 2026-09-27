# Machine role ("work" or "personal"), written by install.sh
role_file = File.expand_path("~/.config/dotfiles/role")
work = File.exist?(role_file) && File.read(role_file).strip == "work"

tap "anomalyco/tap"
tap "darrylmorley/whatcable"

# Shell
brew "starship"
brew "stow"
brew "zoxide"
brew "atuin"
brew "zsh-syntax-highlighting"

# Git & forges
brew "gh"
brew "git-lfs"
brew "lazygit"

# Dev CLIs
brew "fd"
brew "fzf"
brew "ripgrep"
brew "shellcheck"
brew "lychee"
brew "websocat"
brew "wget"
brew "pnpm"

# Data & media
brew "ffmpeg"
brew "vips"
brew "imagemagick"
brew "gdal"
brew "graphviz"
brew "pandoc"
brew "miller"

# AI tools
brew "herdr"
brew "anomalyco/tap/opencode", trusted: true
cask "claude-code@latest"

# Apps
cask "ghostty"
cask "iterm2"
cask "raycast"
cask "betterdisplay"
cask "darrylmorley/whatcable/whatcable", trusted: true
cask "font-hack-nerd-font"

# Work only
if work
  brew "glab"
  brew "gitlab-runner"
  cask "copilot-cli"
  cask "docker-desktop"
end
