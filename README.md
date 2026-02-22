# Dotfiles
---

This repository manages shell and application configuration using GNU Stow, with a Makefile

## Prerequisites
---

- `git`
- `stow`
- `make`

```bash
# MacOS
brew install stow

# Debian
sudo apt update && sudo apt install stow make

# Fedora
sudo dnf update && sudo dnf install stow make

# Arch
sudo pacman -S stow make
```

## Install
---
Clone the repository into `~/.dotfiles`
```bash
git clone git@github.com:danielt812/dotfiles.git .dotfiles
```

Repository layout:
```bash
~/.dotfiles/
    config/ # packages meant for $XDG_CONFIG_HOME
    home/ # packages meant for $HOME
```

## Stow via Makefile
---
All Stow commands are wrapped by `make` targets.

From inside the repo
```bash
cd "$HOME/.dotfiles"
```

## Dry run
```bash
make dry
```

## Apply (`stow`)
```bash
make stow
```

## Restow
```bash
make restow
```

## Uninstall (`unstow`)
```bash
make unstow
```

## Adopt existing files
Move existing files into the repo and replace them with symlinks.
```bash
make adopt
```
Use `adopt` carefully if you already track a file in the repo, because it can overwrite the repo copy with the machine's current copy.

## Conflicts
---
If Stow reports conflicts (existing files that are not owned by Stow), you have two options:

Backup and remove the conflicting files, then re-run `make stow`, or

Use `make adopt` to move the existing files into this repo and replace them with symlinks.

## Shell setup (`bash` and `zsh`)
---
This repo expects shared shell config to live under:

- ~/.config/sh/exports.sh
- ~/.config/sh/aliases.sh
- ~/.config/sh/functions.sh

After stowing config, add the following to the end of your shell rc file.

## Bash
---
```bash
# Source shared shell config
: "${XDG_CONFIG_HOME:="$HOME/.config"}"
SH_DIR="$XDG_CONFIG_HOME/sh"

[ -f "$SH_DIR/exports.sh" ] && . "$SH_DIR/exports.sh"
[ -f "$SH_DIR/aliases.sh" ] && . "$SH_DIR/aliases.sh"
[ -f "$SH_DIR/functions.sh" ] && . "$SH_DIR/functions.sh"
```

## Zsh
---
```zsh
# Source shared shell config
: ${XDG_CONFIG_HOME:="$HOME/.config"}
SH_DIR="$XDG_CONFIG_HOME/sh"

[[ -f "$SH_DIR/exports.sh" ]] && source "$SH_DIR/exports.sh"
[[ -f "$SH_DIR/aliases.sh" ]] && source "$SH_DIR/aliases.sh"
[[ -f "$SH_DIR/functions.sh" ]] && source "$SH_DIR/functions.sh"
```

## Uninstall
---
```bash
cd "$HOME/.dotfiles"
stow -D -t "$HOME" home
stow -D -t "$XDG_CONFIG_HOME" config
```
