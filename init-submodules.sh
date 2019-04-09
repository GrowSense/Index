echo "Initializing GreenSense index submodules"

DIR=$PWD

git submodule update --init --recursive || "Submodule update failed"

for GROUP_DIR in sketches/*; do
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    INIT_SCRIPT="init.sh"
    
    if [ -f $INIT_SCRIPT ]; then
      echo "Running init.sh script..."
      sh $INIT_SCRIPT
    else
      sh "init.sh script not found."
    fi
    
    cd $DIR
  done
done

echo "Finished initializing submodules"
