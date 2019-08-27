JSON_VALUE=$(jq -r 'del(.dashboards[0].dashboard[3])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.dashboards[0].dashboard[2])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.dashboards[0].dashboard[1])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.dashboards[0].dashboard[0])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.tabs[4])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.tabs[3])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.tabs[2])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.tabs[1])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.dashboards[4])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.dashboards[3])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.dashboards[2])' template.json)
echo $JSON_VALUE > template.json

JSON_VALUE=$(jq -r 'del(.dashboards[1])' template.json)
echo $JSON_VALUE > template.json
