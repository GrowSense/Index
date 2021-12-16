echo "Testing the GrowSense index project..."

DIR=$PWD

if [ -z "$CATEGORY" ]; then
    CATEGORY="Unit"
fi

CATEGORY_INCLUDE=" --include=$CATEGORY"


mono lib/NUnit.Runners.2.6.4/tools/nunit-console.exe bin/Release/*.dll $CATEGORY_INCLUDE || exit 1

#cd tests/nunit/ && \
#sh test-software.sh && \
#cd $DIR && \

#sh clean.sh && \

echo "" && \
echo "Testing complete"

