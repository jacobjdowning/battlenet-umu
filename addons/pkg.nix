{ writeShellApplication, lib, instawow,
  wowVersions ? []
}:
writeShellApplication {
	name = "decInstaWow";
	runtimeInputs = [ instawow ];
	runtimeEnv = builtins.listToAttrs (map (profile:{
		name = lib.toUpper (lib.join "_" [profile.name "addons"]);
		value = lib.join ";" profile.addons;
	}) wowVersions);
	text = builtins.readFile ./sync-addons.sh; 
}

