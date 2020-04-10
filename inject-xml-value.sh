echo "Injecting XML value into file..."

XML_FILE=$1
XML_PATH=$2
XML_VALUE=$3
VALUE_HIDDEN=$4

EXAMPLE="Syntax:\n\t...sh [XML_FILE] [XML_PATH] [XML_VALUE] [IS_HIDDEN]"

if [ ! "$XML_FILE" ]; then
  echo "Please provide an XML path as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! "$XML_PATH" ]; then
  echo "Please provide an XML path as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! "$XML_VALUE" ]; then
  echo "Please provide an XML value as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! "$VALUE_HIDDEN" ]; then
  VALUE_HIDDEN=0
fi


#echo "  XML File: $XML_FILE"
#echo "  XML Path: $XML_PATH"
#if [ "$VALUE_HIDDEN" = 1 ]; then
#  echo "  XML Value: [hidden]"
#else
#  echo "  XML Value: $XML_VALUE"
#fi
#echo "  Value Hidden: $VALUE_HIDDEN"

if [ ! -f $XML_FILE ]; then
  echo "XML file not found:"
  echo "  $XML_FILE"
  exit 1
fi

xmlstarlet ed -L -u "$XML_PATH" -v "$XML_VALUE" $XML_FILE || exit 1

XML_FILE_CONTENT=$(cat "$XML_FILE")

# Disabled. Only used for debugging.
#echo "${XML_FILE_CONTENT}"

[[ ! $(echo "$XML_FILE_CONTENT") =~ "$XML_VALUE" ]] && echo "The value wasn't inserted into the XML file..." && echo "  File: $XML_FILE" && echo "  Value: $XML_VALUE" && exit 1

echo "Finished injecting value into XML file"
