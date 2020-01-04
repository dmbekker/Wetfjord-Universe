#!/bin/bash

# Script to download Wetfjord's (encrypted) world backup and store it for $KEEP_DAYS (default 7)
#
# Script will download from $URL_WORLD, then check the file checksum.
# If all is OK file will be renamed to prepend the current date to the file.
# If script is run multiple times per day, the file will be overwritten when renamed.
#
#
# Script created by David, use as you like.

### ---- SCRIPT INIT
echo "INFO: Script execution started"
echo "INFO: Loading config.sh"
[ -f "config.sh" ] || { echo >&2 "ERROR: Config file not yet created. Please see instructions in config.sh.dist  Aborting."; exit 1; }

source config.sh
if [ $? -ne 0 ]; then
    echo >&2 "ERROR: Failed to load config. There is probably a syntax error. Aborting"; exit 1
fi

TODAY=$(date +"%Y_%m_%d")


### ---- Checking if things exists.
[  -d "$DEST_DIR" ] || { echo >&2 "ERROR: Directory $DEST_DIR does not exists. Please create this directory.  Aborting."; exit 1; }

command -v wget >/dev/null 2>&1 || { echo >&2 "ERROR: Script requires wget but it's not installed.  Aborting."; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo >&2 "ERROR: Script requires sha256sum but it's not installed.  Aborting."; exit 1; }

### ---- DOWNLOAD FROM WETFJORD.EU ----
echo "INFO: Trying to download file"

wget $URL_WORLD -P $DEST_DIR -nc
if [ $? -ne 0 ]; then
    echo >&2 "ERROR: Wget failed to download $URL_WORLD. Aborting"; exit 1
fi
wget $URL_SUM -P $DEST_DIR -nc
if [ $? -ne 0 ]; then
    echo >&2 "ERROR: Wget failed to download $URL_SUM. Aborting"; exit 1
fi

LOCAL_WORLD=$DEST_DIR$(basename "$URL_WORLD")
LOCAL_SUM=$DEST_DIR$(basename "$URL_SUM")

### ---- Check if file matches checksum ----
echo "INFO: Files downloaded. Will now validate the SHA256 checksum"
cd $DEST_DIR
sha256sum -c $LOCAL_SUM
if [ $? -ne 0 ]; then
    echo >&2 "ERROR: SHA256 checksum does not match. Try running the script again, if that does not fix the issue the source files are probably corrupt. ";
    echo "INFO: This script will now delete the files just downloaded"
    rm -i $LOCAL_WORLD
    rm -i $LOCAL_SUM

    cd $OLDPWD
    echo >&2 "ERROR: Aborting."
    exit 1
fi
cd $OLDPWD

# Cleanup checksum file, not needed anymore
rm -f $LOCAL_SUM || { echo >&2 "WARNING: Failed to remove checksum file.";}


### ---- RENAMING FILE INTO PLACE ----
mv $LOCAL_WORLD "${DEST_DIR}WetfjordBCK_${TODAY}.zip" || { echo >&2 "WARNING: Failed to rename file. Will continue, but script will fail next run since file is still in place.";}

echo "INFO: World backup saved to "${DEST_DIR}WetfjordBCK_${TODAY}.zip""

### ---- CLEAN OLD DOWNLOADS ----
echo "INFO: Cleaning downloads older then $KEEP_DAYS days"
echo "INFO: The following files will now be removed:"
find $DEST_DIR -maxdepth 1 -name "*.zip"  -type f -mtime +$KEEP_DAYS  -print -delete


echo "INFO: Script execution done"
