echo "Caching git repository..."
DIR=$PWD
if [ ! -d ../../../GrowSense/Index.reference ]; then
  git clone --recursive http://github.com/GrowSense/Index.git ../../../GrowSense/Index.reference
fi
cd ../../../GrowSense/Index.reference
git submodule update --init
cd $DIR
echo "Finished caching git repository."