declare -r installer_url="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"

export WINEPREFIX=$BNET_PREFIX
gamePath="$WINEPREFIX"/drive_c/"$WIN_PATH"

if [ ! -f "$WINEPREFIX"/drive_c/"$BNET_PATH" ]; then
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

