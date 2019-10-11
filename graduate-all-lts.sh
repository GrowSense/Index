#!/bin/bash

echo "Graduating GrowSense index and all submodules..."

DIR=$PWD

for GROUP_DIR in sketches/*; do
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    GRADUATE_LTS_SCRIPT="graduate-lts.sh"
    
    if [ -f $GRADUATE_LTS_SCRIPT ]; then
      echo "Running graduate to lts script..."
      sh $GRADUATE_LTS_SCRIPT
    fi
    
    cd $DIR
  done
done

sh graduate-lts.sh

echo "Finished graduating all to lts branch"
cd $DIR
