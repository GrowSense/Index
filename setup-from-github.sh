echo ""
echo "Setting up GreenSense index from GitHub"
echo ""

BRANCH=$1

if [ "$BRANCH" = "" ]; then
  if [ -d ".git" ]; then
    BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
  else
    BRANCH="master"
  fi
fi

echo "Branch: $BRANCH"

if ! type "git" > /dev/null; then
  sudo apt-get update && sudo apt-get install -y git
fi

git clone --recursive https://github.com/GreenSense/Index.git GreenSense/Index -b $BRANCH && \

echo "Current directory:"
echo "  $PWD"

INDEX_DIR="GreenSense/Index" && \

echo "GreenSense index directory:" && \
echo "  $INDEX_DIR" && \

cd $INDEX_DIR && \

sh prepare.sh && \
sh init.sh && \

echo "" && \
echo "The GreenSense index is initialized and ready to use."



