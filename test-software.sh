echo "Testing the GreenSense index project..."

DIR=$PWD

cd tests/nunit/ && \
sh test-software.sh && \
cd $DIR && \

sh clean.sh && \

echo "" && \
echo "Testing complete"

