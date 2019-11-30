echo ""
echo "Stopping all garden services"
echo ""

DIR=$PWD

bash stop-supervisor.sh || echo "Failed to stop supervisor"

bash stop-mesh-manager.sh || echo "Failed to stop mesh manager"

bash stop-garden-devices.sh || echo "Failed to stop garden devices"
