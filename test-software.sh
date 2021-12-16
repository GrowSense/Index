echo "Testing the GrowSense index project..."

DIR=$PWD

bash test.sh Unit
bash test.sh Fast
bash test.sh Slow

#cd tests/nunit/ && \
#sh test-software.sh && \
#cd $DIR && \

sh clean.sh && \

echo "" && \
echo "Testing complete"

