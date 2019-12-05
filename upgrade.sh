echo "Launching upgrade..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "  Branch: $BRANCH"

bash cache-repository.sh $BRANCH || exit 1
bash upgrade-garden-device-sketches.sh || exit 1
mkdir -p logs/updates || exit 1
bash run-background.sh "bash upgrade-system.sh >> logs/updates/system.txt" # Run this in the background so it's not stopped during upgrade

echo "Finished launching upgrade."
