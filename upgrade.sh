echo "Launching upgrade..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo ""
echo "  Branch: $BRANCH"

echo ""
echo "  Caching repository/updating cache...."
bash cache-repository.sh $BRANCH || exit 1

echo ""
echo "  Upgrading device sketches..."
bash upgrade-garden-device-sketches.sh || exit 1

echo ""
echo "  Upgrading system sketches..."
bash upgrade-system.sh || exit 1

echo "Finished launching upgrade."
