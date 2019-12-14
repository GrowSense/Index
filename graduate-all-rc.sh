#!/bin/bash

echo "Graduating GrowSense index and all submodules..."

DIR=$PWD

for GROUP_DIR in sketches/*; do
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    GRADUATE_RC_SCRIPT="graduate-rc.sh"
    
    if [ -f $GRADUATE_RC_SCRIPT ]; then
      echo "Running graduate to rc script..."
      sh $GRADUATE_RC_SCRIPT || exit 1
    fi
    
    cd $DIR
  done
done

cd www/SystemManagerWWW && \
sh graduate-rc.sh || exit 1
cd $DIR

sh graduate-rc.sh || exit 1

echo "Finished graduating all to rc branch"
cd $DIR
