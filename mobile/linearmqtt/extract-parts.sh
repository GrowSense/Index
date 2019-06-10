echo "Extracting Linear MQTT Dashboard json parts from template..."

mkdir -p parts

echo ""
echo "Summary..."

SUMMARY_DASHBOARD=$(jq -r '.dashboards[0]' settings.json) || exit 1
echo $SUMMARY_DASHBOARD > parts/summarydashboard.json

echo ""
echo "Monitor..."

MONITOR_SUMMARY=$(jq -r '.dashboards[0].dashboard[0]' settings.json) || exit 1
echo $MONITOR_SUMMARY > parts/monitorsummary.json

MONITOR_TAB=$(jq -r '.tabs[1]' settings.json) || exit 1
echo $MONITOR_TAB > parts/monitortab.json

MONITOR_DASHBOARD=$(jq -r '.dashboards[1]' settings.json) || exit 1
echo $MONITOR_DASHBOARD > parts/monitordashboard.json

echo ""
echo "Irrigator..."

IRRIGATOR_SUMMARY=$(jq -r '.dashboards[0].dashboard[1]' settings.json) || exit 1
echo $IRRIGATOR_SUMMARY > parts/irrigatorsummary.json

IRRIGATOR_TAB=$(jq -r '.tabs[2]' settings.json) || exit 1
echo $IRRIGATOR_TAB > parts/irrigatortab.json

IRRIGATOR_DASHBOARD=$(jq -r '.dashboards[2]' settings.json) || exit 1
echo $IRRIGATOR_DASHBOARD > parts/irrigatordashboard.json

echo ""
echo "Ventilator..."

VENTILATOR_SUMMARY=$(jq -r '.dashboards[0].dashboard[2]' settings.json) || exit 1
echo $VENTILATOR_SUMMARY > parts/ventilatorsummary.json

VENTILATOR_TAB=$(jq -r '.tabs[3]' settings.json) || exit 1
echo $VENTILATOR_TAB > parts/ventilatortab.json

VENTILATOR_DASHBOARD=$(jq -r '.dashboards[3]' settings.json) || exit 1
echo $VENTILATOR_DASHBOARD > parts/ventilatordashboard.json

echo ""
echo "Illuminator..."

ILLUMINATOR_SUMMARY=$(jq -r '.dashboards[0].dashboard[3]' settings.json) || exit 1
echo $ILLUMINATOR_SUMMARY > parts/illuminatorsummary.json

ILLUMINATOR_TAB=$(jq -r '.tabs[4]' settings.json) || exit 1
echo $ILLUMINATOR_TAB > parts/illuminatortab.json

ILLUMINATOR_DASHBOARD=$(jq -r '.dashboards[4]' settings.json) || exit 1
echo $ILLUMINATOR_DASHBOARD > parts/illuminatordashboard.json

echo ""
echo "Finished extracting Linear MQTT Dashboard json parts from template"
