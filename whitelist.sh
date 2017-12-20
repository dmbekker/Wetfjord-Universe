#!/bin/bash
#date 20-12-2017
#version: 1.1
#author Vbloetjes
#Comment: This script automates the whitelisting and notifying of a minecraft player.
playername="${1}"
email="${2}"
admins="emailshere"
file=/path/to/file/whitelist.json
screensession=wetfjordsurvival


UUID_URL=https://api.mojang.com/users/profiles/minecraft/$1
status_code=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $UUID_URL)

#does the profile excist?
if [ $status_code = "204" ]; then 
	echo "Error adding player "$1" to the whitelist, player not premium or wrong username?" | mail -s "Whitelisting failed" $admins
	exit;
else

	#get UUID and put group it with "-" inbetween
	mojang_output="`wget -qO- $UUID_URL`"
	rawUUID=${mojang_output:7:32}
	UUID=${rawUUID:0:8}-${rawUUID:8:4}-${rawUUID:12:4}-${rawUUID:16:4}-${rawUUID:20:12}
fi

#check if the player is already whitelisted by searching for the UUID in whitelist.json
if grep -w -q "$UUID" "$file"; then
	echo "Error adding player "$1" to the whitelist, player already whitelisted!" | mail -s "Whitelisting failed" $admins
exit;
fi

#add the player to the whitelist
screen -R "$screensession" -X stuff "whitelist add $playername $(printf '\r')"
screen -R "$screensession" -X stuff "whitelist reload $(printf '\r')"

echo -e "Hello! \n  You have been whitelisted at Wetfjord! Because of the automated systems we use it may take up to 10 minutes for the changes to apply. \n  The server-IP is: wetfjord.eu. \n  See you ingame! \n  /the admins of Wetfjord \n \n \n This is an automated email. If you reply to it your responses won't be read. \n Want to contact us? Use our discord server or the feedback form on our website. " |mail -s "welcome to Wetfjord!" $admins $2
echo "The following player has been whitelisted: $playername " | mail -s "$playername is now whitelisted" $admins

