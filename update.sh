echo "Updating repository..."

BRANCH=$1

if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi

echo "  Branch: $BRANCH"

echo ""
echo "  Updating repository cache..."
bash cache-repository $BRANCH || exit 1

echo ""
echo "  Pulling from origin..."
git pull origin $BRANCH || exit 1

echo ""
echo "  Updating submodules..."
git submodule update --init || exit 1

echo""
echo "Finished updating repository."