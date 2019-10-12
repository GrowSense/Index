DIR=$PWD

echo "" && \
echo "Initializing GrowSense index unit tests" && \

sh init-apps.sh && \

cd tests/nunit/ && \
sh init.sh && \
cd $DIR && \

echo "Done"
