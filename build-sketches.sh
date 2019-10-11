echo "Building GrowSense index device sketches"

DIR=$PWD

for GROUP_DIR in sketches/*; do
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    BUILD_SCRIPT="build-sketch.sh"
    
    if [ -f "$BUILD_SCRIPT" ]; then
      echo "Running build-sketch.sh script..."
      sh $BUILD_SCRIPT
    else
      echo "build-sketch.sh script not found. Skipping."
    fi
    
    cd $DIR
  done
done

echo "Finished building device sketches"
