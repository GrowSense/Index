mkdir -p parts && \

# Unzip the linear MQTT config file

rm -f settings.json && \
unzip config.linear && \

# Extract the template parts

SUMMARY_DASHBOARD=$(jq '.dashboards[0]' settings.json) && \
echo $SUMMARY_DASHBOARD > parts/summarydashboard.json && \

MONITOR_SUMMARY=$(jq '.dashboards[0].dashboard[0]' settings.json) && \
echo $MONITOR_SUMMARY > parts/monitorsummary.json && \

MONITOR_TAB=$(jq '.tabs[1]' settings.json) && \
echo $MONITOR_TAB > parts/monitortab.json && \

MONITOR_DASHBOARD=$(jq '.dashboards[1]' settings.json) && \
echo $MONITOR_DASHBOARD > parts/monitordashboard.json && \

IRRIGATOR_SUMMARY=$(jq '.dashboards[0].dashboard[1]' settings.json) && \
echo $IRRIGATOR_SUMMARY > parts/irrigatorsummary.json && \

IRRIGATOR_TAB=$(jq '.tabs[2]' settings.json) && \
echo $IRRIGATOR_TAB > parts/irrigatortab.json && \

IRRIGATOR_DASHBOARD=$(jq '.dashboards[2]' settings.json) && \
echo $IRRIGATOR_DASHBOARD > parts/irrigatordashboard.json && \

# Create the blank template file

cp settings.json template.json && \

JSON_VALUE=$(jq 'del(.dashboards[0].dashboard[1])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.dashboards[0].dashboard[0])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.tabs[2])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.tabs[1])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.dashboards[2])' template.json) && \
echo $JSON_VALUE > template.json && \

JSON_VALUE=$(jq 'del(.dashboards[1])' template.json) && \
echo $JSON_VALUE > template.json && \

# Copy the template file to the new settings file as a starting point
cp template.json newsettings.json && \

echo "Extraction complete"
