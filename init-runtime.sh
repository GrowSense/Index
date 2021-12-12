echo "[init-runtime.sh] Initializing runtime..."

BRANCh=$1

echo "ARG1: $1"

if [ ! "$BRANCH" ]; then
  echo "  Branch argument not provided. Using git branch..."
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi
if [ ! "$BRANCH" ]; then
  echo "  Branch argument not provided. Using default lts branch..."
  BRANCH="lts"
fi

echo "[init-runtime.sh]  Branch: $BRANCH"

# TODO: Clean up. Should be obsolete now installation is done from zip file not git repo
#bash init-apps.sh $BRANCH && \
bash init-sketches.sh && \
bash init-www.sh || exit 1
