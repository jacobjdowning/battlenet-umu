declare -r installer_url="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"

export WINEPREFIX=$BNET_PREFIX
gamePath="$WINEPREFIX"/drive_c/"$WIN_PATH"
bnetPath="$WINEPREFIX"/drive_c/"$BNET_PATH" 

# if this script needs to message the user and isn't in a visual termianl
# then launch a new terminal

if [ ! -f "$bnetPath" ] || [ ! -f "$gamePath" ]; then
	if [ ! -t 0 ]; then
		exec xdg-terminal-exec "$0" "$@"
	fi
fi

if [ ! -f "$bnetPath" ]; then
	echo "Battle.net is not installed at C:/$BNET_PATH"
	while true; do
		read -rp "Would you like to install it now? [y/n]:" answer
		case $answer in
			[Nn]*) echo "Aborting Install"; exit 1 ;;
			[Yy]*) break ;;
		esac
	done

	mkdir -p "$WINEPREFIX/drive_c"
	installer=$(mktemp --suffix=.exe -p "$WINEPREFIX/drive_c")
	trap 'rm -f "$installer"' EXIT
	
	if ! curl -fL -o "$installer" "$installer_url"; then
		read -rn 1 -p "Download Failed [Press any key to exit]"
		exit 1
	fi

	umu-run "$installer"
	rm -f "$installer"
elif [ ! -f "$gamePath" ]; then
	read -rn 1 -p "There is no game installed at $gamePath, please install it with Battle.net (Press any key to close)"
	exit 1
else
	umu-run "$gamePath" "$LAUNCH_ARGS"
fi

