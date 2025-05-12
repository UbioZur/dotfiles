## ~  UbioZur - https://github.com/UbioZur  ~ ##

# Allow unicode for TTY fonts
unicode_start

# Make sure my bash is configured for the TTY also
if [ -n "$PS1" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
