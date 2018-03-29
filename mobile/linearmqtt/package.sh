echo ""
echo "Packaging config.linear file"
echo ""
echo "Location:"
echo "$PWD/output/config.linear"
echo ""

mkdir -p output && \

cp newsettings.json output/settings.json && \

cd output && \

zip -r config.linear settings.json
