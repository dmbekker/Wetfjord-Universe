#!/bin/bash
#date 16-05-2019
#version: 1.2
#author Vbloetjes
#Comment: This script automates the whitelisting of a minecraft player.
playername="${1}"
file=/path/to/file/whitelist.json
screensession=wetfjordsurvival


UUID_URL=https://api.mojang.com/users/profiles/minecraft/$1
status_code=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $UUID_URL)

#does the profile exist?
if [ $status_code = "204" ]; then 
	echo "Error adding player "$1" to the whitelist, player not premium or wrong username?"
	exit;
else

	#get UUID and put group it with "-" inbetween
	mojang_output="`wget -qO- $UUID_URL`"
	rawUUID=${mojang_output:7:32}
	UUID=${rawUUID:0:8}-${rawUUID:8:4}-${rawUUID:12:4}-${rawUUID:16:4}-${rawUUID:20:12}
fi

#check if the player is already whitelisted by searching for the UUID in whitelist.json
if grep -w -q "$UUID" "$file"; then
	echo "Error adding player "$1" to the whitelist, player already whitelisted!"
exit;
fi

#add the player to the whitelist
if ! [ -z "$(screen -ls | grep "$screensession")" ]; then 
	screen -R "$screensession" -X stuff "whitelist add $playername $(printf '\r')"
	echo ""$1" is now whitelisted"
else
	echo "The screensession "$screensession" has not been found, player not whitelisted!"
fi
