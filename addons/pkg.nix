{ writeShellApplication, lib, instawow,
  wowVersions ? [],
  bnetPrefix ? "TestGames/battlenet" 
}:
writeShellApplication {
	name = "sync-addons";
	runtimeInputs = [ instawow ];
	runtimeEnv = builtins.listToAttrs (lib.concatMap (profile: let
		name = lib.toUpper profile.name;
	in
	[
		{
			name = "${name}_ADDONS"; 
			value = lib.join "\n" profile.addons;
		}
		{
			name = "${name}_ADDON_DIR";
			value = profile.addonDir;
		}
	]) wowVersions) // {
		BNET_PREFIX = bnetPrefix;
	};
	text = builtins.readFile ./sync-addons.sh; 
}

