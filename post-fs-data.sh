mount -o rw,remount /data
MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug-pfsd.log
set -x

# remove
rm -rf /data/vendor/dolby /data/vendor/media/da*_sqlite3.db


