echo "Initializing GrowSense index submodules"

DIR=$PWD

git submodule update --init --recursive || "Submodule update failed"

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

for GROUP_DIR in sketches/*; do
  echo ""
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo ""
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    INIT_SCRIPT="init.sh"
    
    if [ -f $INIT_SCRIPT ]; then
      echo "Running init.sh script..."
      git checkout $BRANCH || exit 1
      sh $INIT_SCRIPT || exit 1
    else
      echo "init.sh script not found. Skipping."
    fi
    
    cd $DIR
  done
done

echo "Finished initializing submodules"
