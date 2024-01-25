mount -o rw,remount /data
[ ! "$MODPATH" ] && MODPATH=${0%/*}
[ ! "$MODID" ] && MODID=`basename "$MODPATH"`
UID=`id -u`

# log
exec 2>/data/media/"$UID"/$MODID\_uninstall.log
set -x

# remove
rm -rf /data/vendor/dolby /data/vendor/media/da*_sqlite3.db


