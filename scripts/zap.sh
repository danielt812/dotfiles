#!/bin/zsh

# https://github.com/zap-zsh/zap
if [[ -d $ZAP_DIR ]]; then
	echo "zap-zsh is already installed."
else
	echo "installing zap-zsh..."
	zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
fi