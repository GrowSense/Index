echo "Caching git repository..."

DIR=$PWD

BRANCH=$1

if [ ! "$BRANCH" ]; then
  echo "  Error: Please provide a branch name as an argument."
  exit 1
fi

BASE_PATH="/usr/local"

if [ -f "is-mock-system.txt" ]; then
  BASE_PATH="../../../../.."
fi

CACHE_PATH="$BASE_PATH/git-cache/GrowSense/Index"

echo "  Currrent path:"
echo "    $PWD"
echo "  Cache path:"
echo "    $CACHE_PATH"

if [ ! -d "$CACHE_PATH" ]; then
  echo "  Cache doesn't exist. Cloning."
  git clone -j 10 -b $BRANCH --recursive https://github.com/GrowSense/Index.git $CACHE_PATH
fi

cd $CACHE_PATH
echo "  Updating cache..."
#git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
#git fetch --all
git checkout $BRANCH || exit 1
git pull origin $BRANCH || exit 1
git submodule update --init || exit 1

cd $DIR

echo "Finished caching git repository."