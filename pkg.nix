{ writeShellApplication, umu-launcher, proton-ge-bin }:
writeShellApplication {
	name = "bnet-umu";
	runtimeInputs = [ umu-launcher ];
	runtimeEnv = {
		GAMEID = "umu-default";
		PROTONPATH = "${proton-ge-bin.steamcompattool}";
	};
	text = ''
		export WINEPREFIX=$HOME/Games/battlenet	
		exec umu-run "$WINEPREFIX"/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"
	'';
}
