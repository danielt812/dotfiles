# Makefile for GNU Stow dotfiles
# Usage:
#   make dry
#   make stow
#   make unstow
#   make restow
#   make adopt
#   make tpm

SHELL := /bin/bash

DOTFILES_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
HOME_DIR := $(HOME)
XDG_CONFIG_HOME ?= $(HOME_DIR)/.config

STOW := stow
STOW_FLAGS := -v
STOW_DIR_FLAGS := -d "$(DOTFILES_DIR)"

TMUX := tmux

.PHONY: help dry stow unstow restow adopt

help:
	@printf "%s\n" \
	"Targets:" \
	"  dry      Dry-run stow for home + config" \
	"  stow     Apply stow for home + config" \
	"  restow   Restow (unstow then stow) for home + config" \
	"  unstow   Remove symlinks for home + config" \
	"  adopt    Adopt existing files into repo, then stow" \
	"  tpm      Clone tmux plugin manager" \
	"" \
	"Vars:" \
	"  XDG_CONFIG_HOME=$(XDG_CONFIG_HOME)"

dry:
	@cd "$(DOTFILES_DIR)" && \
	$(STOW) -n $(STOW_FLAGS) -t "$(HOME_DIR)" home && \
	$(STOW) -n $(STOW_FLAGS) -t "$(XDG_CONFIG_HOME)" config

stow:
	@cd "$(DOTFILES_DIR)" && \
	$(STOW) $(STOW_FLAGS) -t "$(HOME_DIR)" home && \
	$(STOW) $(STOW_FLAGS) -t "$(XDG_CONFIG_HOME)" config

restow:
	@cd "$(DOTFILES_DIR)" && \
	$(STOW) -R $(STOW_FLAGS) -t "$(HOME_DIR)" home && \
	$(STOW) -R $(STOW_FLAGS) -t "$(XDG_CONFIG_HOME)" config

unstow:
	@cd "$(DOTFILES_DIR)" && \
	$(STOW) -D $(STOW_FLAGS) -t "$(HOME_DIR)" home && \
	$(STOW) -D $(STOW_FLAGS) -t "$(XDG_CONFIG_HOME)" config

adopt:
	@cd "$(DOTFILES_DIR)" && \
	$(STOW) --adopt $(STOW_FLAGS) -t "$(HOME_DIR)" home && \
	$(STOW) --adopt $(STOW_FLAGS) -t "$(XDG_CONFIG_HOME)" config

tpm:
	@if [ ! -d "$(XDG_CONFIG_HOME)/tmux/plugins" ]; then \
		mkdir -p "$(XDG_CONFIG_HOME)/tmux/plugins"; \
	fi; \
	if [ -d "$(XDG_CONFIG_HOME)/tmux/plugins/tpm/.git" ]; then \
		echo "TPM already installed at $(XDG_CONFIG_HOME)/tmux/plugins/tpm"; \
	else \
		git clone https://github.com/tmux-plugins/tpm "$(XDG_CONFIG_HOME)/tmux/plugins/tpm"; \
	fi
