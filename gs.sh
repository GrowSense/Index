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
  mode="Release"
fi

echo "  Mode: $mode"

if [ ! -f "bin/$mode/gs.exe" ]; then
  echo "Error: Can't find bin/$mode/gs.exe binary file. Has the project been compiled?"
  exit 1
fi

mono bin/$mode/gs.exe --dir=$PWD $1 $2 $3 $4 $5 $6 $7 $8 $9 || exit 1

echo "Finished launching GrowSense CLI"
