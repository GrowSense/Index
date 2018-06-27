DIR=$PWD

sh build.sh && \
sh build-submodules.sh && \
sh build-tests.sh &&

cd $DIR

