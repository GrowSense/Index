echo "Caching git repository..."
DIR=$PWD
rm ../GrowSense/Index.reference -R
if [ ! -d ../GrowSense/Index.reference ]; then
  git clone --recursive http://github.com/GrowSense/Index.git ../GrowSense/Index.reference
fi
cd ../GrowSense/Index.reference
git submodule update --init
cd $DIR
echo "Finished caching git repository."