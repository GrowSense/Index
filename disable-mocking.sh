echo "Disabling mocking..."

FILES="is-mock*.txt"
for f in $FILES
do
  if [ -f $f ]; then
    echo "  Removing: $f"
    rm $f
  fi
done
