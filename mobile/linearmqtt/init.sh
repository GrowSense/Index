mkdir -p parts && \

# Unzip the linear MQTT config file

rm -f settings.json && \
unzip -o config.linear && \

cp settings.json settings.json.bak

sh init-settings.sh

#echo "Initialization complete"
