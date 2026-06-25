mount -o rw,remount /data
[ ! "$MODPATH" ] && MODPATH=${0%/*}
[ ! "$MODID" ] && MODID=`basename "$MODPATH"`
UID=`id -u`
[ ! "$UID" ] && UID=0

# log
DIR=/data/adb/logs
mkdir -p $DIR
exec 2>$DIR/$MODID\_uninstall.log
set -x

# remove
rm -rf /data/vendor/dolby /data/vendor/media/da*_sqlite3.db


