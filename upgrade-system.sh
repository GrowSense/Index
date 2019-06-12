echo "Upgrading system..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

INSTALLED_VERSION="$(cat version.txt)-$(cat buildnumber.txt)"

LATEST_BUILD_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/buildnumber.txt" -q -O -)
LATEST_VERSION_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/version.txt" -q -O -)

LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

echo "  Branch: $BRANCH"
echo "  Installed version: $INSTALLED_VERSION"
echo "  Latest version: $LATEST_FULL_VERSION"

if [ "$INSTALLED_VERSION" != "$LATEST_FULL_VERSION" ]; then
  echo "  New GreenSense system version available. Upgrading."
  
  sh clean-all.sh

  sh update-all.sh

  sh init-runtime.sh
else
  echo "  GreenSense system is up to date. Skipping upgrade."
fi

echo "Finished upgrading system"
