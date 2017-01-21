#!/bin/sh 
#TODO: replace folder structure with variables declared in the beginning 
#TODO: announcements

screensession=testserver
serverlocation=/data/testservers/wetfjordTest/serverMinecraft/
serverjar=spigot.jar
option="${1}"
#mem=${2:-1024}
case ${option} in
	-start)
			screen -d -m -S "$screensession"
			sleep 2
			screen -R "$screensession" -X stuff "cd "$serverlocation"\n"
			screen -R "$screensession" -X stuff "java -Xms2048M -Xmx2048M -XX:MaxPermSize=128M -jar "$serverlocation"spigot.jar nogui\n"
		;;
	-restart) #MEM="${2:-1024}"
			screen -R "$screensession" -X stuff "say server will reboot in 30 seconds. Back in 1 minute $(printf '\r')"
			sleep 10
			screen -R "$screensession" -X stuff "say server will reboot in 20 seconds. Back in 1 minute $(printf '\r')"
			sleep 10
			screen -R "$screensession" -X stuff "say server will reboot in 10 seconds. Back in 1 minute $(printf '\r')"
			sleep 5
			screen -R "$screensession" -X stuff "say server will reboot in 5 seconds. Back in 1 minute $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "say server will reboot in 4 seconds. Back in 1 minute $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "say server will reboot in 3 seconds. Back in 1 minute $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "say server will reboot in 2 seconds. Back in 1 minute $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "say server will reboot in 1 second. Back in 1 minute $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "stop $(printf '\r')"
			sleep 20
			cd "$serverlocation"
			screen -R "$screensession" -X stuff 'java -Xms2048M -Xmx2048M -XX:MaxPermSize=128M -jar "$serverlocation"spigot.jar nogui\n'
		;;
	-backup)
			screen -R "$screensession" -X stuff "say Backup starting. You may experience a little lag$(printf '\r')"
			screen -R "$screensession" -X stuff "save-off $(printf '\r')"
			screen -R "$screensession" -X stuff "save-all $(printf '\r')"
			sleep 3
			tar -cpvzf /data/backups/minecraft/wetfjordSurvival/$(date +%y%m%d-%H%M%S).tar.gz /data/serverMinecraft
			screen -R "$screensession" -X stuff "save-on $(printf '\r')"
			screen -R "$screensession" -X stuff "save-all $(printf '\r')"
			sleep 3
			screen -R "$screensession" -X stuff "say Backup completed. $(printf '\r')"
		;;
	-stop)
			screen -R "$screensession" -X stuff "say The server will shut down in 30 seconds. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 10
			screen -R "$screensession" -X stuff "say The server will shut down in 20 seconds. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 10
			screen -R "$screensession" -X stuff "say The server will shut down in 10 seconds. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 10
			screen -R "$screensession" -X stuff "say The server will shut down in 5 seconds. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 5
			screen -R "$screensession" -X stuff "say The server will shut down in 4 seconds. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "say The server will shut down in 3 seconds. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "say The server will shut down in 2 seconds. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "say The server will shut down in 1 second. For more information check facebook/twitter/discord/our website $(printf '\r')"
			sleep 1
			screen -R "$screensession" -X stuff "stop $(printf '\r')"
			sleep 10
			screen -R "$screensession" -x stuff 'exit\n'
			;;
	-delete)
			find /data/backups/minecraft/wetfjordSurvival* -mindepth 1 -mtime +2 -delete
			;;
	-reload)
			screen -R "$screensession" -X stuff "whitelist reload $(printf '\r')"
			;;
	-announcement1)
			screen -R "$screensession" -X stuff "say à¸¢à¸‡2Announcement: Our new wiki will be the central hub of information @ wetfjord. Contribute! www.wetfjord.eu/wiki $(printf '\r')"
			;;
	-announcement2)
			screen -R "$screensession" -X stuff "say Â§2Announcement: Join our discord (skype group replacement)!: https://discord.gg/QH2WfWw  $(printf '\r')"
			;;
   *)
      echo "`basename ${0}`:usage: [-start memory in mb] | [-restart memory in mb] | [-backup] | [-stop] | [-reload] | [-announcement]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac