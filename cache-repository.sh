echo "Caching git repository..."
DIR=$PWD
if [ ! -d ../../../git-cache/GrowSense/Index.reference ]; then
  git clone --recursive --mirror http://github.com/GrowSense/Index.git ../../../git-cache/GrowSense/Index.reference
  #cd ../../../git-cache/GrowSense/Index.reference
  #git submodule update --init
  #cd $DIR
fi
echo "Finished caching git repository."