echo "Installing UI controller"

INSTALL_DIR="/usr/local/Serial1602ShieldSystemUIController"

echo "Install dir:"
echo "  $INSTALL_DIR"

mkdir -p $INSTALL_DIR

cp -v -r Serial1602ShieldSystemUIController/ $INSTALL_DIR/Serial1602ShieldSystemUIController
cp -v Serial1602ShieldSystemUIController*.nupkg $INSTALL_DIR/
cp -v init.sh $INSTALL_DIR/
cp -v install-package.sh $INSTALL_DIR/
cp -v start-ui-controller-from-github.sh $INSTALL_DIR/

