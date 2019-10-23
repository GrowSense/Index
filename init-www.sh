DIR=$PWD

cd www/SystemManagerWWW
sh init.sh && \
sh build.sh  || exit 1

cd $DIR