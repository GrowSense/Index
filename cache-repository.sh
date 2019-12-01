echo "Caching git repository..."
DIR=$PWD
if [ ! -d ../GrowSense/Index.reference ]; then
  git clone --recursive git://github.com/GrowSense/Index.git ../GrowSense/Index.reference
fi
cd ../GrowSense/Index.reference
git submodule init --update
cd $DIR
echo "Finished caching git repository."