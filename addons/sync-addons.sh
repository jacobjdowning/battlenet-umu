installed_addons=$(instawow -p "$1" list)
declared_addon_var="${1^^}_ADDONS"

# the greps stop empty lists from iterating once
mapfile -t to_add < <(comm -13 <(sort <<< "${installed_addons,,}" | grep . ) <(sort <<< "${!declared_addon_var,,}" | grep .))
mapfile -t to_remove < <(comm -23 <(sort <<< "${installed_addons,,}" | grep . ) <(sort <<< "${!declared_addon_var,,}" | grep .))

echo "Removing Addons: "
for addon in "${to_remove[@]}"; do
	instawow -p "$1" remove "$addon"
done

echo "Installing Addons: "
for addon in "${to_add[@]}"; do
	instawow -p "$1" install "$addon"
done
