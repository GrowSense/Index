# TODO: Remove this file if not needed. Should be obsolete. Linear MQTT Dashboard is being phased out.

#DEVICES_DIR="devices"

#DIR=$PWD

#echo "Resetting linear MQTT UI"
#cd mobile/linearmqtt/
#sh reset.sh
#cd $DIR


#echo "Recreating linear MQTT UI"
#if [ -d "$DEVICES_DIR" ]; then
#    for d in $DEVICES_DIR/*; do
    
#      if [ -f $d/name.txt ]; then
#        echo "Found device info:"
#        echo $d
#        DEVICE_GROUP=$(cat $d/group.txt)
#        echo "  Device type: $DEVICE_GROUP"
#        DEVICE_NAME=$(cat $d/name.txt)
#        echo "  Device name: $DEVICE_NAME"
#        DEVICE_LABEL=$(cat $d/label.txt)
#        echo "  Device label: $DEVICE_LABEL"
        
#        if [ "$DEVICE_GROUP" = "ui" ]; then
#          echo "This is a UI device. Skipping UI creation."
#        else
#          IS_DEVICE_UI_CREATED_FLAG_FILE="$d/is-ui-created.txt"
#          echo "0" > $IS_DEVICE_UI_CREATED_FLAG_FILE        
          
#          sh create-garden-$DEVICE_GROUP-ui.sh $DEVICE_LABEL $DEVICE_NAME || exit 1
          
#          echo "1" > $IS_DEVICE_UI_CREATED_FLAG_FILE
#        fi
#      fi
#    done
#else
#    echo "No device info found in $DEVICES_DIR"
#fi
