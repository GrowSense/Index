echo "Building GrowSense index submodules"

DIR=$PWD

for GROUP_DIR in sketches/*; do
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    BUILD_SCRIPT="build-all.sh"
    
    if [ -f "$BUILD_SCRIPT" ]; then
      echo "Running build-all.sh script..."
      sh $BUILD_SCRIPT || exit 1
    else
      echo "build-all.sh script not found. Skipping."
    fi
    
    cd $DIR
  done
done

echo "Finished building submodules"
