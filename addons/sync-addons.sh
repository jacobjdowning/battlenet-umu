#installed_addons=$(instawow -p "$1" list)
installed_addons="github:Tester/test
curse:TestAddon"
declared_addon_var="${1^^}_ADDONS"

mapfile -t to_add < <(comm -13 <(sort <<< "$installed_addons") <(sort <<< "${!declared_addon_var}"))
mapfile -t to_remove < <(comm -23 <(sort <<< "$installed_addons") <(sort <<< "${!declared_addon_var}"))


echo "To remove: ${to_remove[*]}"
echo "To add: ${to_add[*]}"
