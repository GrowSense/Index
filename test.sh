echo "Testing the GrowSense index project..."

DIR=$PWD


mono lib/NUnit.Runners.2.6.4/tools/nunit-console.exe bin/Release/*.dll || exit 1

#cd tests/nunit/ && \
#sh test-software.sh && \
#cd $DIR && \

#sh clean.sh && \

echo "" && \
echo "Testing complete"

