echo "Upgrading to 'next' headers"

sudo apt-get update && \
sudo apt-get install -y linux-headers-next-sunxi

echo "Upgrade complete"
