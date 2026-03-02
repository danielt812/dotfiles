# Navigation -------------------------------------------------------------------
setopt AUTO_CD              # Change directory by typing a directory name without cd
setopt AUTO_PUSHD           # Automatically push directories onto the directory stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories onto the stack
setopt PUSHD_SILENT         # Don't print the directory stack after pushd or popd

# Globbing ---------------------------------------------------------------------
setopt GLOB_DOTS            # Include dotfiles in glob patterns without explicitly specifying the dot
setopt EXTENDED_GLOB        # Enable extended glob operators like ^, ~, and #
setopt NUMERIC_GLOB_SORT    # Sort filenames numerically when it makes sense (e.g. file1, file2, file10)
setopt NULL_GLOB            # Delete a glob pattern if no matches are found, instead of erroring

# Interactive ------------------------------------------------------------------
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells using #
setopt CORRECT              # Offer to correct the spelling of mistyped commands
setopt RC_QUOTES            # Allow '' inside single-quoted strings to represent a literal single quote

# Jobs -------------------------------------------------------------------------
setopt LONG_LIST_JOBS       # List jobs in the long format by default
setopt CHECK_JOBS           # Warn before exiting the shell if there are running or suspended jobs

# Misc -------------------------------------------------------------------------
setopt NO_BEEP              # Disable terminal beep on errors
