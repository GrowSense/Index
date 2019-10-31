#!/bin/bash

FROM_TEXT=$1
TO_TEXT=$2

if [ ! "$FROM_TEXT" ]; then
	echo "Please provide the source text as an argument."
	exit 1
fi

if [ ! "$TO_TEXT" ]; then
	echo "Please provide the new text as an argument."
	exit 1
fi

mkdir -p ../_tmp/
mv .git ../_tmp/

echo "Changing..."
echo "From: $FROM_TEXT"
echo "To: $TO_TEXT"

echo ""
echo "Replacing in file contents..."
find . -type f -exec sed -i "s/$FROM_TEXT/$TO_TEXT/g" {} +

echo ""
echo "Replacing in file and folder names..."
FILES=$(find . -name "*$FROM_TEXT*")

for f in $FILES
do
echo "Processing $f file..."

rename "s/$FROM_TEXT/$TO_TEXT/g" $f -v

done


mv ../_tmp/.git .git

echo "Replace complete"