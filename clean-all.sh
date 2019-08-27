#!/bin/bash

echo "Cleaning, including all submodules..."

DIR=$PWD

for GROUP_DIR in sketches/*; do
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    CLEAN_SCRIPT="clean.sh"
    
    if [ -f $CLEAN_SCRIPT ]; then
      echo "Running clean script..."
      sh $CLEAN_SCRIPT
    fi
    
    cd $DIR
  done
done

echo "Finished cleaning"
cd $DIR
