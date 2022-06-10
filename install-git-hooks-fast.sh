PRE_COMMIT_FILE=".git/hooks/pre-commit"
COMMAND="bash build-tests.sh; bash clean.sh; bash increment-version.sh"

if [ -f $PRE_COMMIT_FILE ]; then
    cp "$PRE_COMMIT_FILE" "$PRE_COMMIT_FILE.bak"
fi

echo "#!/bin/sh\n$COMMAND" > $PRE_COMMIT_FILE

chmod +x $PRE_COMMIT_FILE


echo "Updated: $PRE_COMMIT_FILE"
echo "Done"
