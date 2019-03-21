
# Restore the backed up settings
cp settings.json.bak settings.json -f

# Extract the template parts
sh extract-parts.sh

# Create the blank template file
cp settings.json template.json && \

# Remove devices from the template
sh strip-template.sh && \

# Copy the template file to the new settings file as a starting point
cp template.json newsettings.json

#echo "Finished initializing settings"
