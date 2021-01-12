bash disable-mocking.sh
bash clean.sh && \
git commit -am "$1" && \
git pull origin dev && \
git pull local dev &&  \
git push origin dev && \
git push local dev
