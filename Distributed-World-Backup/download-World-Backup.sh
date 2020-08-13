#!/bin/bash

# Script to download Wetfjord's (encrypted) world backup and store it for $KEEP_DAYS (default 7)
#
# Script will download from $URL_WORLD
# If all is OK file will be renamed to prepend the current date to the file.
# If script is run multiple times per day, the file will be overwritten when renamed.
#
#
# Script created by David, use as you like.

### ---- SCRIPT INIT

CONFIGFILE="$(dirname "$0")/config.sh"

echo "INFO: Script execution started"
echo "INFO: Loading config.sh: $CONFIGFILE"

[ -f $CONFIGFILE ] || { echo >&2 "ERROR: Config file not yet created. Please see instructions in config.sh.dist  Aborting."; exit 1; }
source $CONFIGFILE

if [ $? -ne 0 ]; then
    echo >&2 "ERROR: Failed to load config. There is probably a syntax error. Aborting"; exit 1
fi

TODAY=$(date +"%Y_%m_%d")
YESTERDAY=$(TZ=GMT date -d 'yesterday' '+%a, %d %b %Y %T %Z') # Formats date compliant rfc7232, section 3.3


### ---- Checking if things exists.
[  -d "$DEST_DIR" ] || { echo >&2 "ERROR: Directory $DEST_DIR does not exists. Please create this directory.  Aborting."; exit 1; }

command -v wget >/dev/null 2>&1 || { echo >&2 "ERROR: Script requires wget but it's not installed.  Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "ERROR: Script requires curl but it's not installed.  Aborting."; exit 1; }


### ---- CHECK IF WORLD BACKUP WITH TODAYS DATE ALREADY EXISTS
if [ -f "${DEST_DIR}WetfjordBCK_${TODAY}.tar.gz.gpg" ]; then
    echo >&2 "ERROR: World download for ${TODAY} already exists. Aborting"; exit 1
fi


### ---- CHECK IF FILE HAS CHANGED SINCE 24 HOURS AGO
echo "INFO: Checking remote Last Modified Date"

curl -I -s --header 'If-Modified-Since: '$YESTERDAY $URL_WORLD | grep "304 Not Modified"
curlexit=$?
if [ "$1" = "--force" ]; then
  if [ $curlexit -eq 0 ]; then
      echo >&2 "ERROR: World download has not been modified in the last 24 hours. No need to download it. Use --force switch to override downlaoding. Aborting"; exit 1
  fi
fi


### ---- DOWNLOAD FROM WETFJORD.EU ----
echo "INFO: Trying to download file"

wget $URL_WORLD -P $DEST_DIR -nc
if [ $? -ne 0 ]; then
    echo >&2 "ERROR: Wget failed to download $URL_WORLD. Aborting"; exit 1
fi


### ---- RENAMING FILE INTO PLACE ----
LOCAL_WORLD=$DEST_DIR$(basename "$URL_WORLD")
mv $LOCAL_WORLD "${DEST_DIR}WetfjordBCK_${TODAY}.tar.gz.gpg" || { echo >&2 "WARNING: Failed to rename file. Will continue, but script will fail next run since file is still in place.";}

echo "INFO: World backup saved to "${DEST_DIR}WetfjordBCK_${TODAY}.tar.gz.gpg""

### ---- CLEAN OLD DOWNLOADS ----
echo "INFO: Cleaning downloads older then $KEEP_DAYS days"
echo "INFO: The following files will now be removed:"
find $DEST_DIR -maxdepth 1 -name "*.tar.gz.gpg"  -type f -mtime +$KEEP_DAYS  -print -delete


echo "INFO: Script execution done"
