#!/bin/sh 

ARMA3_PARAMS="./arma3server -cfg=/data/steam/arma3/install/basic.cfg -config=/data/steam/arma3/install/server.cfg -name=public -mod=@RHSAFRF\;@RHSGREF\;@RHSUSAF -enableHT -exThreads=7 -port=2302 -noSound"
TF2_PARAMS="./srcds_run -console -game tf -nohltv +sv_pure 1 +map dm_mariokart2_b3 +maxplayers 24 +servercfgfile"
HL2DM_PARAMS="./srcds_run -game hl2mp +maxplayers 20 +map dm_killbox_kbh +hostname Wetfjord +sv_voiceenable 0 +mp_falldamage 0 +sv_gravity 180 +port 27020"

option="${1}"
#mem=${2:-1024}
case ${option} in
	-start_arma3) screensession="arma3"
			screen -d -m -S "$screensession"
			sleep 2
			screen -R "$screensession" -X stuff "cd /data/steam/arma3/install/\n"
			screen -R "$screensession" -X stuff "$ARMA3_PARAMS\n"
		;;
	-restart_arma3) screensession="arma3"
			screen -R "$screensession" -X stuff ^C
			sleep 10
			screen -R "$screensession" -X stuff "$ARMA3_PARAMS\n"
		;;
	-start_tf2) screensession="tf2"
			screen -d -m -S "$screensession"
			sleep 2
			screen -R "$screensession" -X stuff "cd /data/steam/tf2\n"
			screen -R "$screensession" -X stuff "$TF2_PARAMS\n"
		;;
	-restart_tf2) screensession="tf2"
			screen -R "$screensession" -X stuff ^C
			sleep 10
			screen -R "$screensession" -X stuff "$TF2_PARAMS\n"
			;;
	-start_hl2dm) screensession="hl2dm"
			screen -d -m -S "$screensession"
			sleep 2
			screen -R "$screensession" -X stuff "cd /data/steam/hl2dm\n"
			screen -R "$screensession" -X stuff "$HL2DM_PARAMS\n"
			;;
	-restart_hl2dm) screensession="hl2dm"
			screen -R "$screensession" -X stuff ^C
			sleep 10
			screen -R "$screensession" -X stuff "$HL2DM_PARAMS\n"
			;;
	-update)
			/data/steam/arma3/a3update
			;;
   *)
      #todo:
      echo "`basename ${0}`:usage: [-start memory in mb] | [-restart memory in mb] | [-backup] | [-stop] | [-reload] | [-announcement]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac
