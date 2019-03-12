# This forces mono 4 to be installed instead of mono 5.
# Some systems only work with mono 4

# For this export to work the script needs to be called like this:
# . ./use-mono4.sh

echo "Setting the environment variable..."

export USE_MONO4=1

echo "USE_MONO4=$USE_MONO4"

echo "Done"
