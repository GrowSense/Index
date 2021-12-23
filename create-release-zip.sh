echo "[create-release-zip.sh] Packaging release zip file..."

DIR=$PWD

RELEASES_FOLDER="releases"

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

VERSION_POSTFIX=""

if [ "$BRANCH" != "lts" ]; then
  VERSION_POSTFIX="-$BRANCH"
fi

sh clean.sh
bash disable-mocking.sh

#bash increment-version.sh

VERSION="$(cat version.txt)-$(cat buildnumber.txt)"

echo "$VERSION" > full-version.txt

if [ -d "releases" ]; then
  echo "  Removing releases folder..."
  rm $RELEASES_FOLDER -R
fi
mkdir -p $RELEASES_FOLDER


echo ""
echo "[create-release-zip.sh]   Zipping release..."
zip -qq -r $DIR/releases/GrowSense-Index.$VERSION$VERSION_POSTFIX.zip * -x */obj/* *.git/*


#git checkout full-version.txt
#git checkout buildnumber.txt

echo ""
echo "[create-release-zip.sh] Finished packaging release zip file."
