mkdir -p parts && \

# Unzip the linear MQTT config file

rm -f settings.json && \
unzip -o config.linear && \

# Extract the template parts
sh extract-parts.sh

# Create the blank template file
cp settings.json template.json && \

# Remove devices from the template
sh strip-template.sh && \

# Copy the template file to the new settings file as a starting point
cp template.json newsettings.json && \

echo "Extraction complete"
