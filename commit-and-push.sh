echo "Committing and pushing to repository..."
echo ""

bash disable-mocking.sh
bash clean.sh && \
git commit -am "$1" && \
git pull origin dev && \
git push origin dev

git pull local dev || echo "Failed to pull from local repository"
git push local dev || echo "Failed to push to local repository"

echo ""
echo "Finished committing and pushing to repository"
