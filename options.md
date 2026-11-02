## programs\.battlenet-umu\.enable



Whether to enable umu-launcher for battle\.net games\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/umu/module\.nix](file:///umu/module.nix)



## programs\.battlenet-umu\.addons\.enable

Whether to enable addon control through instawow\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.package



Package of instawow to use to sync



*Type:*
package



*Default:*

```nix
<derivation instawow-7.0.0.post1>
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.extraConfig



This option has no description\.



*Type:*
JSON value



*Default:*

```nix
{ }
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.tokens



API tokens for addon providers



*Type:*
submodule

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.tokens\.cfcore



This option has no description\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.tokens\.github



This option has no description\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.tokens\.wagoAddons



This option has no description\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.versions



Descriptions of the different versions of WoW



*Type:*
list of (submodule)

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.versions\.\*\.addonDir



Path to the Addons folder within the prefix’s C:/ drive



*Type:*
string

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.versions\.\*\.addons



A list of addons for this version



*Type:*
list of string matching the pattern (github|curse|tukui|wago|wowi):\[^\[:space:]]+



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "github:sfx-wow/masque"
]
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.versions\.\*\.extraConfig



This option has no description\.



*Type:*
JSON value



*Default:*

```nix
{ }
```

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.versions\.\*\.flavour



The version of WoW these addons are for



*Type:*
one of “mainline”, “vanilla_classic”, “forever_classic”, “tbc_classic”, “wrath_classic”, “titan_classic”, “cata_classic”, “mists_classic”

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.addons\.versions\.\*\.name



Name of the instawow profile for this version



*Type:*
string matching the pattern \[A-Za-z0-9_]+

*Declared by:*
 - [/addons/module\.nix](file:///addons/module.nix)



## programs\.battlenet-umu\.games



A list of battle\.net game definitions



*Type:*
list of (submodule)



*Default:*

```nix
[
  {
    name = "Battle.net";
  }
]
```

*Declared by:*
 - [/umu/module\.nix](file:///umu/module.nix)



## programs\.battlenet-umu\.games\.\*\.launchArgs



Any launch options to be sent to the exe



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/umu/module\.nix](file:///umu/module.nix)



## programs\.battlenet-umu\.games\.\*\.name



Name of the game installed



*Type:*
string

*Declared by:*
 - [/umu/module\.nix](file:///umu/module.nix)



## programs\.battlenet-umu\.games\.\*\.path



Path to the executable within the prefix’s C:/ drive



*Type:*
string



*Default:*

```nix
"Program Files (x86)/Battle.net/Battle.net Launcher.exe"
```

*Declared by:*
 - [/umu/module\.nix](file:///umu/module.nix)



## programs\.battlenet-umu\.games\.\*\.proton



The proton package used for the game



*Type:*
package



*Default:*

```nix
<derivation proton-ge-bin-GE-Proton11-1>
```

*Declared by:*
 - [/umu/module\.nix](file:///umu/module.nix)



## programs\.battlenet-umu\.prefix



Wine Prefix for the umu-launcher for your battle\.net games



*Type:*
absolute path



*Default:*

```nix
"/home/user/.local/share/battlenet-umu/prefix"
```

*Declared by:*
 - [/umu/module\.nix](file:///umu/module.nix)


