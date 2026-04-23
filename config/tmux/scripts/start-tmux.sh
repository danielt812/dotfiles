#!/usr/bin/env bash
# Open Terminal.app and attach to an existing tmux session.
# Creates a new session only if no tmux server is running.

osascript <<-EOF
tell application "Terminal"
	if not (exists window 1) then reopen
	activate
	set winID to id of window 1
	do script "tmux attach || tmux new-session" in window id winID
	tell application "Finder"
		set desktopSize to bounds of window of desktop
	end tell
	set bounds of window id winID to desktopSize
end tell
EOF
