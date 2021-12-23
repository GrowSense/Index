echo "Testing the GrowSense index project..."

DIR=$PWD

CATEGORY=$1

if [ ! "$CATEGORY" ]; then
    CATEGORY="Unit"
fi

#CATEGORY_INCLUDE=" --include=$CATEGORY"

echo "  Category: $CATEGORY"


mono lib/NUnit.Runners.2.6.4/tools/nunit-console.exe bin/Release/*Tests.dll --include="$CATEGORY" || exit 1

#cd tests/nunit/ && \
#sh test-software.sh && \
#cd $DIR && \

#sh clean.sh && \

echo "" && \
echo "Testing complete"

