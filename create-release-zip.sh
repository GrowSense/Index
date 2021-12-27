echo "[create-release-zip.sh] Creating release zip file..."

DIR=$PWD

RELEASES_FOLDER="releases"

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

VERSION_POSTFIX=""

if [ "$BRANCH" != "lts" ]; then
  VERSION_POSTFIX="-$BRANCH"
fi

VERSION="$(cat version.txt)-$(cat buildnumber.txt)"

echo "$VERSION" > full-version.txt

echo "  Version: $VERSION"
echo "  Branch: $BRANCH"

sh clean.sh
bash disable-mocking.sh

#bash increment-version.sh

if [ -d "releases" ]; then
  echo "  Removing releases folder..."
  rm $RELEASES_FOLDER -R
fi
mkdir -p $RELEASES_FOLDER


echo ""
echo "[create-release-zip.sh]   Zipping release..."
zip -qq -r $DIR/releases/GrowSense-Index.$VERSION$VERSION_POSTFIX.zip . \
 -x '/.circleci*' \
 -x '/.git*' \
 -x '/deployments/*' \
 -x '/logs/*' \
 -x '/msgs/*' \
 -x '/obj/*' \
 -x '/releases/*' \
 -x '/security/*' \
 -x '*.security' \
 -x 'growsense.settings' \
 -x 'is-mock-*.txt' \
 -x '/tests/*' \
 -x '*/tests/*' \
 -x '/tmp/*' \
 -x '/src/*'


#git checkout full-version.txt
#git checkout buildnumber.txt

echo ""
echo "[create-release-zip.sh] Finished creating release zip file."
