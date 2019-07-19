echo "Installing UI controller"

INSTALL_DIR="/usr/local/Serial1602ShieldSystemUIController"

echo "Install dir:"
echo "  $INSTALL_DIR"

mkdir -p $INSTALL_DIR

cp -v -r Serial1602ShieldSystemUIController/ $INSTALL_DIR/Serial1602ShieldSystemUIController
cp -v Serial1602ShieldSystemUIController*.nupkg $INSTALL_DIR/
cp -v init.sh $INSTALL_DIR/
cp -v install-package-from-github-release.sh $INSTALL_DIR/
cp -v Serial1602ShieldSystemUIControllerConsole.exe.config.system $INSTALL_DIR/Serial1602ShieldSystemUIControllerConsole.exe.config
cp -v start-ui-controller.sh $INSTALL_DIR/

