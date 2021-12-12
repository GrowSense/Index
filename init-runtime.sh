echo "Initializing runtime..."

BRANCh=$1

if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi
if [ ! "$BRANCH" ]; then
  BRANCH="lts"
fi

echo "  Branch: $BRANCH"

sh init-apps.sh $BRANCH && \
sh init-sketches.sh && \
sh init-www.sh || exit 1
