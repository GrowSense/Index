
COUNTRY_CODE=$1

if [ ! "$COUNTRY_CODE" ]; then
  echo "Specify the country code as an argument."
  exit 1
fi

echo "Setting country code..."
echo "  Country code: $COUNTRY_CODE"

cp country-code.txt country-code-previous.txt

echo $COUNTRY_CODE > country-code.txt

echo "Finished setting country code."

