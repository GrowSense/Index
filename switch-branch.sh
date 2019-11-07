BRANCH=$1

if [ ! $BRANCH ]; then
  BRANCH="lts"
fi

DIR=$PWD
for GROUP_DIR in sketches/*; do
  echo ""
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo ""
    echo "Project: $PROJECT_DIR"
    
    cd "$PROJECT_DIR"
    
    git checkout $BRANCH || exit 1
    
    cd $DIR
  done
done

cd www/SystemManagerWWW
git checkout $BRANCH || exit 1
cd $DIR

echo "Finished switching to $BRANCH"
