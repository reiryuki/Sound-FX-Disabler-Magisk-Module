MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug.log
set -x

# var
API=`getprop ro.build.version.sdk`

# prop
resetprop -n ro.audio.ignore_effects true

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek

# stop
NAMES="dms-hal-1-0 dms-hal-2-0 dms-v36-hal-2-0 dms-sp-hal-2-0"
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
    if [ -f $FILE ]; then
      if [ -L $MODPATH/system/vendor ]\
      && [ -d $MODPATH/vendor ]; then
        mount -o bind $MODPATH/vendor$FILE $FILE
      else
        mount -o bind $MODPATH/system/vendor$FILE $FILE
      fi
    fi
  done
fi

# audio flinger
DMAF=`dumpsys media.audio_flinger`


