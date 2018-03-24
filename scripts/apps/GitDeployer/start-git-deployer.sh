sh init.sh

echo "Launching deployer."

mono GitDeployer/lib/net40/GitDeployer.exe $1 $2 $3 $4 $5
