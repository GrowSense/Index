echo "Updating submodules by checking out the master branch and pulling from origin..."

BRANCH=$1

if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi

echo "Branch: $BRANCH"
echo "Dir: $PWD"
DIR=$PWD

git submodule update --init --recursive || exit 1

for GROUP_DIR in sketches/*; do
  echo ""
  echo "Group: $GROUP_DIR"
  for PROJECT_DIR in $GROUP_DIR/*; do
    echo ""
    echo "Project: $PROJECT_DIR"

    cd "$PROJECT_DIR"

    if [ -f "clean.sh" ]; then
      echo "Updating submodule..."
      echo "  Fetching..."
      git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
      git fetch origin || exit 1
      echo "  Cleaning..."
      bash clean.sh || exit 1
      echo "  Checking out $BRANCH..."
      git checkout -f $BRANCH || exit 1
      echo "  Pulling $BRANCH from origin..."
      git pull origin $BRANCH || exit 1

#      bash clean.sh || exit 1
#      git fetch origin $BRANCH || exit 1
#      git checkout -b $BRANCH || exit 1
#      git pull origin $BRANCH || exit 1
    else
      echo "clean.sh script not found. Skipping."
    fi

    cd $DIR
  done
done

echo "Updating SystemManagerWWW"

cd www/SystemManagerWWW && \
sh clean.sh && \
git fetch origin $BRANCH && \
git checkout -f $BRANCH && \
git pull origin $BRANCH || exit 1

cd $DIR

echo "Finished updating submodules"
