echo "Installing UI controller"

INSTALL_DIR="/usr/local/Serial1602ShieldSystemUIController"

echo "Install dir:"
echo "  $INSTALL_DIR"

mkdir -p $INSTALL_DIR

cp -v -r Serial1602ShieldSystemUIController/ $INSTALL_DIR/Serial1602ShieldSystemUIController || exit 1
cp -v Serial1602ShieldSystemUIController*.zip $INSTALL_DIR/ || exit 1
cp -v init.sh $INSTALL_DIR/ || exit 1
cp -v install-package-from-github-release.sh $INSTALL_DIR/ || exit 1
cp -v Serial1602ShieldSystemUIControllerConsole.exe.config.system $INSTALL_DIR/Serial1602ShieldSystemUIControllerConsole.exe.config || exit 1
cp -v start-ui-controller.sh $INSTALL_DIR/ || exit 1

