IFS=";" read -r -a addons <<< "$ERA_ADDONS"

for addon in "${addons[@]}"; do
	echo "$addon"
done
