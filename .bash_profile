if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
#       export DESKTOP_SESSION=openbox
#       startx ~/.xinitrc /usr/bin/openbox-session
        export DESKTOP_SESSION=dwm
	### In order for java apps to work. For details refer to https://wiki.archlinux.org/title/Dwm#Troubleshooting
	export _JAVA_AWT_WM_NONREPARENTING=1
        startx ~/.xinitrc /usr/local/bin/dwm
else
	if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
		# include .bashrc if it exists
		if [ -f "$HOME/.bashrc" ]; then
			. "$HOME/.bashrc"
	    	fi
	fi
fi
