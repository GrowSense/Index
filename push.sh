BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# Disabled local repository because it's not currently in use
#git pull local $BRANCH || echo "Failed to pull from local repository"
#git push local $BRANCH || echo "Failed to push to local repository"

git pull lan $BRANCH || echo "Failed to pull from lan repository"
git push lan $BRANCH || echo "Failed to push to lan repository"

git pull origin $BRANCH && \
git push origin $BRANCH

