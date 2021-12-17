echo "Committing and pushing to repository..."
echo ""

bash disable-mocking.sh
bash clean.sh && \
bash increment-version.sh && \
git commit -am "$1" && \

sh push.sh

echo ""
echo "Finished committing and pushing to repository"
