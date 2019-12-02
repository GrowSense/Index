echo "Caching git repository..."

DIR=$PWD

BRANCH=$1

if [ ! "$BRANCH" ]; then
  echo "  Error: Please provide a branch name as an argument."
  exit 1
fi

CACHE_PATH="/usr/local/git-cache/GrowSense/Index"
#rm $CACHE_PATH -R

if [ ! -d "$CACHE_PATH" ]; then
  echo "  Cache doesn't exist. Cloning."
  git clone -j 10 -b $BRANCH --recursive http://github.com/GrowSense/Index.git $CACHE_PATH
fi

cd $CACHE_PATH
echo "  Updating cache..."
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch --all
git checkout $BRANCH
git pull origin $BRANCH
git submodule update --init

cd $DIR

echo "Finished caching git repository."