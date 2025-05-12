## ~  UbioZur - https://github.com/UbioZur  ~ ##

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -z "$PS1" ] && return

# Clear the screen and add an empty line
\clear
echo ""

# Setup XDG Directories
export XDG_DATA_HOME="${XDG_DATA_HOME-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME-$HOME/.cache}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR-/run/user/$UID}"

# Define the BASH Config Directory
export _BASH_CONFIG_DIR="${XDG_CONFIG_HOME}/bash"

# Source All Configuration Files
for f in ${_BASH_CONFIG_DIR}/bashrc.d/*; do source $f; done


#### Initialize Zoxide

if [ -x /usr/bin/zoxide ]; then
	\eval "$(zoxide init bash)"
fi

#### Allow unicode for TTY fonts
unicode_start

#### Show Fastfetch on first startup

if [ -x /usr/bin/fastfetch ]; then
	__ffconfigdir="${XDG_CONFIG_HOME}/fastfetch/"
	__hostname="$(hostname)"
	if [ -f "${__ffconfigdir}${__hostname}.jsonc" ]; then
		/usr/bin/fastfetch -c "${__ffconfigdir}${__hostname}.jsonc"
	elif [ -f "${__ffconfigdir}default.jsonc" ]; then
		/usr/bin/fastfetch -c "${__ffconfigdir}default.jsonc"
	else
		/usr/bin/fastfetch
	fi
fi
