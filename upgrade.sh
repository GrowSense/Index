echo "Launching upgrade..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "  Branch: $BRANCH"

bash cache-repository.sh $BRANCH && \
bash upgrade-garden-device-sketches.sh && \
bash run-background.sh bash upgrade-system.sh >> logs/updates/system.txt # Run this in the background so it's not stopped during upgrade

echo "Finish launching upgrade."
