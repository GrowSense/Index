echo "Caching git repository..."

DIR=$PWD

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

CACHE_PATH="../../git-cache/GrowSense/Index.reference"
#rm $CACHE_PATH -R

if [ ! -d $CACHE_PATH ]; then
  echo "  Cache doesn't exist. Cloning."
  git clone -b $BRANCH --recursive http://github.com/GrowSense/Index.git $CACHE_PATH
fi

cd $CACHE_PATH
git pull origin $BRANCH
git submodule update --init
cd $DIR

echo "Finished caching git repository."