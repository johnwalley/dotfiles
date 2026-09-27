# My dotfiles

This directory contains the dotfiles for my system

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone https://github.com/johnwalley/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks. Preview first with a dry run:

```
$ stow -nv .        # dry run: show what would be linked, change nothing
$ stow .            # create the symlinks
```

If a target file already exists on the machine (e.g. a stock `~/.zshrc`),
stow will refuse with a conflict. Either back it up and delete it, or let
stow pull it into the repo:

```
$ stow --adopt .    # moves existing files into the repo, then links them
$ git diff          # review — keep repo version with `git checkout .` if desired
```

After editing or adding files, re-link with restow:

```
$ stow -R .
```
