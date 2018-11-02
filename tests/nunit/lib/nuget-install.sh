PACKAGE_NAME=$1
PACKAGE_VERSION=$2

if [ ! "$PACKAGE_NAME" ]; then
	echo "Please provide a package name as an argument."
	exit 1
fi

if [ ! "$PACKAGE_VERSION" ]; then
	echo "Please provide a package version as an argument."
	exit 1
fi

echo "Package name: $PACKAGE_NAME"
echo "Package version: $PACKAGE_VERSION"

PACKAGE_FILE="$PACKAGE_NAME.$PACKAGE_VERSION"
PACKAGE_FILE_EXT="$PACKAGE_NAME.$PACKAGE_VERSION.nupkg"

echo "Package file: $PACKAGE_FILE"

NUGET_INSTALL_ERROR=0

if [ ! -d "$PACKAGE_FILE" ]; then

	# Nuget is disabled because it's slower than direct download and is not currently required
	#mono nuget.exe install $PACKAGE_NAME -version $PACKAGE_VERSION || NUGET_INSTALL_ERROR=1

	# Force direct download
	NUGET_INSTALL_ERROR=1

	if [ $NUGET_INSTALL_ERROR=1 ]; then
		wget -q "https://github.com/GreenSense/libs/raw/master/$PACKAGE_FILE.nupkg" -O $PACKAGE_FILE_EXT

		unzip -o "$PACKAGE_FILE_EXT" -d "$PACKAGE_FILE/"
	fi
else
	echo "$PACKAGE_FILE library already exists. Skipping download."
fi
