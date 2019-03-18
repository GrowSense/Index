DIR=$PWD

echo "" && \
echo "Initializing GreenSense index unit tests" && \

cd tests/nunit/ && \
sh init.sh && \
cd $DIR && \

echo "Done"
