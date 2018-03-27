echo ""
echo "Setting up GreenSense index from GitHub"
echo ""

git clone --recursive https://github.com/GreenSense/Index.git GreenSense/Index && \

CURRENT_DIR=$PWD && \

echo "Current directory:"
echo "  $CURRENT_DIR"

INDEX_DIR="$CURRENT_DIR/GreenSense/Index" && \

echo "GreenSense index directory:"
echo "  $INDEX_DIR"

cd $INDEX_DIR && \

sh prepare.sh && \
sh init.sh && \

cd $INDEX_DIR && \

echo "" && \
echo "The GreenSense index is initialized and ready to use."
