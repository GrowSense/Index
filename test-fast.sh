echo "Testing the GreenSense index project..."

DIR=$PWD

cd tests/nunit/ && \
sh test-fast.sh && \
cd $DIR && \

sh clean.sh && \

echo "" && \
echo "Testing complete"

