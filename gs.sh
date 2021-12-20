echo "Launching GrowSense CLI..."

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            --mode)              mode=${VALUE} ;;
            *)   
    esac    


done

if [ ! "$mode" ]; then
  mode="Debug"
fi

echo "  Mode: $mode"

mono bin/$mode/gs.exe --dir=$PWD $1 $2 $3 $4 $5 $6 $7 $8 $9
