let
	pkgs = import <nixpkgs> { };
	lib = pkgs.lib;
	eval = lib.evalModules {
		specialArgs = { inherit pkgs; };
		modules = [
			../umu/module.nix
			../addons/module.nix
			{
				config._module.check = false;
				options.xdg = { configHome = lib.mkOption { type = lib.types.str; default = "/home/user/.config"; };
				      dataHome   = lib.mkOption { type = lib.types.str; default = "/home/user/.local/share"; };
				      stateHome  = lib.mkOption { type = lib.types.str; default = "/home/user/.local/state"; };
				      cacheHome  = lib.mkOption { type = lib.types.str; default = "/home/user/.cache"; };
				};
			}
		];
	};

	optionsDoc = pkgs.nixosOptionsDoc {
		options = removeAttrs eval.options [ "_module" "xdg" ];
		warningsAreErrors = false;
		transformOptions = opt: opt // {
			declarations = map (dec:
				let str = toString dec; in
				lib.removePrefix (toString ./..) str
			) opt.declarations;
		};
	};
in

	pkgs.runCommand "options.md" {} ''
		cat ${optionsDoc.optionsCommonMark} >> $out
	''
