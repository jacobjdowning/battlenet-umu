{
	description = "A Home Manager module for battle.net including addons";

	outputs = { ... }: {
		homeModules.default = ./module.nix; 
	};
}
