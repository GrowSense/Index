echo "Testing the GrowSense index project..."

DIR=$PWD

bash test.sh

cd tests/nunit/ && \
sh test-all.sh && \
cd $DIR && \

sh clean.sh && \

echo "" && \
echo "Testing complete"

