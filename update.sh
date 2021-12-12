echo "Updating repository..."

BRANCH=$1

if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi

echo "  Branch: $BRANCH"

#echo ""
#echo "  Updating repository cache..."
#bash cache-repository.sh $BRANCH || exit 1

#echo ""
#echo "  Checking out $BRANCH..."
#git checkout -f $BRANCH || exit 1

#echo ""
#echo "  Pulling from origin..."
#git pull origin -X theirs $BRANCH || exit 1

#echo ""
#echo "  Updating submodules..."
#git submodule update --init || exit 1


  RELEASE_URL=$(curl -s https://api.github.com/repos/GrowSense/Index/releases | jq -r '.[0].assets[0].browser_download_url') || exit 1

  echo "$RELEASE_URL"

  LOCAL_RELEASE_FILE="GrowSenseRelease.zip"

  mkdir -p .tmp

  cp *.txt .tmp/

  curl -L -o $LOCAL_RELEASE_FILE $RELEASE_URL || exit 1
  unzip -o $LOCAL_RELEASE_FILE -d . || exit 1

  mv .tmp/*.txt ./

  rm $LOCAL_RELEASE_FILE

echo ""
echo "Finished updating repository."
