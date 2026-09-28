# Homebrew (Apple Silicon, Intel, Linux) — also sets $HOMEBREW_PREFIX
for p in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$p" ] && eval "$("$p" shellenv)" && break
done
