echo "Deleting GitHub release..."

. ./project.settings

if [ -f "set-github-token.sh.security" ]; then
 . ./set-github-token.sh.security
else
  GITHUB_TOKEN=$GHTOKEN
fi

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

VERSION="$(cat version.txt)-$(cat full-version.txt)"
#VERSION="2-0-0-136"

echo "  Version: $VERSION"

POSTFIX=""
if [ $BRANCH != "lts" ]; then
  POSTFIX="-$BRANCH"
fi

R=""
#R=$RANDOM

REPOSITORY="$GITHUB_OWNER/$GITHUB_PROJECT"
TAG="v$VERSION$R$POSTFIX"
RELEASE_NAME="$GITHUB_OWNER-$GITHUB_PROJECT.$VERSION$POSTFIX"
RELEASE_DESCRIPTION="$GITHUB_OWNER $GITHUB_PROJECT $VERSION$POSTFIX $R"

PRERELEASE="true"
if [ $BRANCH = "lts" ]; then
  PRERELEASE="false"
fi

echo "  Repository: $REPOSITORY"
echo "  Tag: $TAG"
echo "  Release name: $RELEASE_NAME"
echo "  Prerelease: $PRERELEASE"
echo ""

CURL="curl https://api.github.com/repos/GrowSense/Index/releases"
#echo $(eval "$CURL/tags/v$VERSION-$BRANCH")
#exit 1

# Get existing release ID
ASSET_ID=$(eval "$CURL/tags/v$VERSION-$BRANCH" | jq .id);
echo $ASSET_ID

if [ "$ASSET_ID" == "null" ]; then
  echo "Release not found. Skipping deletion..."
fi


#ASSET_ID=55861623
#exit 1
# Create a release
#$RELEASE_RESPONSE=$(curl -XPOST -H 'Cache-Control: no-cache' -H "Authorization:token $GITHUB_TOKEN" --data "{\"tag_name\": \"$TAG\", \"target_commitish\": \"$BRANCH\", \"name\": \"$RELEASE_NAME\", \"body\": \"$RELEASE_DESCRIPTION\", \"draft\": false, \"prerelease\": $PRERELEASE}" https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_PROJECT/releases)
URL="https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_PROJECT"
RELEASE_URL="$URL/releases/$ASSET_ID"
echo "  Release URL: $RELEASE_URL"
curl -qq -H "Authorization:token $GITHUB_TOKEN" --request DELETE "$RELEASE_URL"
curl -H "Authorization:token $GITHUB_TOKEN" --request DELETE "$URL/git/refs/tags/$TAG"


echo ""
echo ""
echo "Finished deleting release."
