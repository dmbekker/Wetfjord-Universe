# Distributed World Backup
download-World-Backup.sh is a script to download the latest Wetfjord Encrypted backup for Minecraft.

## Use
1. Open config.sh.dist
2. Edit the variables
	* `URL_WORLD`: The link to the ZIP-file to be downloaded
	* `URL_SUM`: The link to the ZIP's checksum-file to be downloaded
	* `DEST_DIR`: Directory on your local filesystem, where to store the downloaded files
	* `KEEP_DAYS`: For how long to keep a downloaded ZIP-file. Will be deleted after.
3. Rename config.sh.dist to config.sh
4. Run download.sh, expect to find a file in $DEST_DIR, named as follows `WetfjordBCK_YYYY_MM_DD.ZIP`
5. If all did go well, create a cronjob to run download.sh on a interval

## Questions?
Hit up @d4v1d on the Discord