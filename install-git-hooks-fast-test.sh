PRE_COMMIT_FILE=".git/hooks/pre-commit"
COMMAND="sh clean.sh; sh init-mock-setup.sh; sh build-tests.sh; sh test-fast.sh; sh clean.sh"

if [ -f $PRE_COMMIT_FILE ]; then
    cp "$PRE_COMMIT_FILE" "$PRE_COMMIT_FILE.bak"
fi

echo "#!/bin/sh\n$COMMAND" > $PRE_COMMIT_FILE

chmod +x $PRE_COMMIT_FILE


echo "Updated: $PRE_COMMIT_FILE"
echo "Done"
