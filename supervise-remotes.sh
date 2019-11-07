echo "Supervising remote indexes/computers..."

for d in remote/*; do
  if [ -d $d ]; then
    REMOTE_NAME=$(cat $d/name.security)

    echo ""
    bash supervise-remote.sh $REMOTE_NAME
    echo ""

  fi
done

echo "Finished supervising remote indexes/computers"