MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug.log
set -x

# var
API=`getprop ro.build.version.sdk`
if [ -L $MODPATH/system/vendor ]; then
  mkdir -p $MODPATH/vendor
fi
if [ ! -d $MODPATH/vendor ]\
|| [ -L $MODPATH/vendor ]; then
  MODSYSTEM=/system
fi
MOD=/data/adb/modules/nomount
NM=$MOD/bin/nm
NOMOUNT=false
[ ! -f $MOD/disable ] && [ -x $NM ] && $NM v >/dev/null 2>&1 && NOMOUNT=true

# prop
resetprop -n ro.audio.ignore_effects true
resetprop -n ro.audio.soundfx.dirac false
resetprop -n ro.feature.dolby_enable false
resetprop -n ro.product.lge.globaleffect.dts false
resetprop -n ro.lge.globaleffect.dts false

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek\
 android.hardware.audio.service

# stop
NAMES="dms-hal-1-0 dms-hal-2-0
       dms-v36-hal-2-0 dms-sp-hal-2-0"
for NAME in $NAMES; do
  stop $NAME
done

# mount
DIR=/odm/bin/hw
FILES="$DIR/vendor.dolby_sp.hardware.dmssp@2.0-service
       $DIR/vendor.dolby_v3_6.hardware.dms360@2.0-service
       $DIR/vendor.dolby.hardware.dms@2.0-service
       $DIR/vendor.dolby.hardware.dms@1.0-service"
if [ "`realpath $DIR`" == $DIR ]; then
  for FILE in $FILES; do
    MODFILE=$MODPATH$MODSYSTEM/vendor$FILE
    if [ -f $FILE ]; then
      if $NOMOUNT; then
        $NM del $FILE 2>/dev/null || true
        $NM add $FILE $MODFILE
      else
        umount $FILE
        mount -o bind $MODFILE $FILE
      fi
    fi
  done
fi


