echo "Pushing submodule updates..."

sh clean.sh

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

git pull origin $BRANCH && \
git commit -am "Updated submodules [ci-skip]" && \
git push origin $BRANCH || exit 1

echo "Finished pushing submodule updates"
