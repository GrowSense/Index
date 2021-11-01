git pull local dev || echo "Failed to pull from local repository"
git push local dev || echo "Failed to push to local repository"

git pull lan dev || echo "Failed to pull from lan repository"
git push lan dev || echo "Failed to push to lan repository"

git pull origin dev && \
git push origin dev

