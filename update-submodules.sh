echo "Updating submodules by checking out the master branch and pulling from origin..."

BRANCH=$1

if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi

echo "Branch: $BRANCH"
echo "Dir: $PWD"
DIR=$PWD

#git submodule update --init --recursive || exit 1

for GROUP_DIR in sketches/*; do
  echo ""
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo ""
    echo "Project: $PROJECT_DIR"

    cd "$PROJECT_DIR"

    if [ -f "clean.sh" ]; then
      echo "Updating submodule..."
      bash clean.sh || exit 1
      git fetch origin $BRANCH || exit 1
      git checkout -b origin/$BRANCH || exit 1
      git pull origin $BRANCH || exit 1
    else
      echo "clean.sh script not found. Skipping."
    fi

    cd $DIR
  done
done

echo "Updating SystemManagerWWW"

cd www/SystemManagerWWW && \
sh clean.sh && \
git checkout $BRANCH && \
git pull origin $BRANCH || exit 1

cd $DIR

echo "Finished updating submodules"
