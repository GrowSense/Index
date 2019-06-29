VERSION=$1

echo "Setting plug and play version..."

if [ ! $VERSION ]; then
  echo "Please provide a version as an argument."
  exit 1
fi

echo "  Version: $VERSION"

echo ""

echo "  Plug and play app init.sh script:"
APP_INIT_SCRIPT="scripts/apps/ArduinoPlugAndPlay/init.sh"
echo "    $APP_INIT_SCRIPT"

sed -i "s/sh install-package.sh ArduinoPlugAndPlay .* |/sh install-package.sh ArduinoPlugAndPlay $VERSION |/" $APP_INIT_SCRIPT || exit 1

echo ""

echo "  Tests get-libs.sh script:"
TESTS_GET_LIBS_SCRIPT="tests/nunit/lib/get-libs.sh"
echo "    $TESTS_GET_LIBS_SCRIPT"

sed -i "s/ArduinoPlugAndPlay .* |/ArduinoPlugAndPlay $VERSION |/" $TESTS_GET_LIBS_SCRIPT || exit 1

echo ""

echo "Finished setting plug and play version"
