#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_cwd=$(echo "$cwd" | sed "s|^$home|~|")

# Get git branch (skip optional locks)
branch=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

# Build the status line using printf for color support
# Directory in bold cyan, branch in yellow, model in blue, context in green
printf "\033[1;36m%s\033[0m" "$short_cwd"

if [ -n "$branch" ]; then
  printf " \033[0;33m(%s)\033[0m" "$branch"
fi

if [ -n "$model" ]; then
  printf " \033[0;34m%s\033[0m" "$model"
fi

if [ -n "$used_pct" ]; then
  printf " \033[0;32mctx:%.0f%%\033[0m" "$used_pct"
fi
