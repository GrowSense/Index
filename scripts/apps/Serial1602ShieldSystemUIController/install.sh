echo "Installing UI controller"

INSTALL_DIR=$1

if [ ! $INSTALL_DIR ]; then
  INSTALL_DIR="/usr/local/Serial1602ShieldSystemUIController"
fi

echo "  Install dir:"
echo "    $INSTALL_DIR"

if [ -d "$INSTALL_DIR" ]; then
  echo "  Removing previous serial UI controller..."
  rm $INSTALL_DIR -R
fi

echo "  Creating new serial UI controller directory..."
mkdir -p $INSTALL_DIR

cp -v -r Serial1602ShieldSystemUIController/ $INSTALL_DIR/Serial1602ShieldSystemUIController/ || exit 1
cp -v Serial1602ShieldSystemUIController*.zip $INSTALL_DIR/ || exit 1
cp -v init.sh $INSTALL_DIR/ || exit 1
cp -v install-package-from-github-release.sh $INSTALL_DIR/ || exit 1
cp -v Serial1602ShieldSystemUIControllerConsole.exe.config.system $INSTALL_DIR/Serial1602ShieldSystemUIControllerConsole.exe.config || exit 1
cp -v start-ui-controller.sh $INSTALL_DIR/ || exit 1

echo "Finished installing serial UI controller"
