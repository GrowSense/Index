#!/bin/bash

REPOSITORY_OWNER=$1
PACKAGE_NAME=$2
PACKAGE_VERSION=$3

if [ ! "$REPOSITORY_OWNER" ]; then
	echo "Please provide a repository owner as an argument."
	exit 1
fi

if [ ! "$PACKAGE_NAME" ]; then
	echo "Please provide a package name as an argument."
	exit 1
fi

if [ ! "$PACKAGE_VERSION" ]; then
	echo "Please provide a package version as an argument."
	exit 1
fi

echo "Installing package $PACKAGE_NAME $PACKAGE_VERSION..."

PACKAGE_FILE="$PACKAGE_NAME.$PACKAGE_VERSION"
PACKAGE_FILE_EXT="$PACKAGE_NAME.$PACKAGE_VERSION.zip"
PACKAGE_FOLDER="$PACKAGE_NAME"
PACKAGE_FOLDER_WITH_VERSION="$PACKAGE_NAME.$PACKAGE_VERSION"

#echo "  Package file: $PACKAGE_FILE"

# If the package folder isn't found
if [ ! -f "$PACKAGE_FILE_EXT" ]; then

  # Check if the project exists within the GrowSense index
	[[ $(echo $PWD) =~ "GrowSense/Index" ]] && IS_IN_INDEX=1 || IS_IN_INDEX=0
	
	if [ $IS_IN_INDEX ]; then
	  # Get the path to the GrowSense index lib directory
	  INDEX_LIB_DIR=$(readlink -f "../../../lib")
	  
	  #echo "  GrowSense index lib directory:"
	  #echo "    $INDEX_LIB_DIR"
	  
	  # Check if the package exists in the GrowSense inject lib directory
    if [ -d "$INDEX_LIB_DIR/$PACKAGE_FOLDER_WITH_VERSION" ]; then
      echo "  From GrowSense index lib directory"
      # Copy the package from the GrowSense index lib directory
      cp -r $INDEX_LIB_DIR/$PACKAGE_FOLDER_WITH_VERSION $PACKAGE_FOLDER || exit 1
      cp -r $INDEX_LIB_DIR/$PACKAGE_FILE_EXT $PACKAGE_FILE_EXT || exit 1
    fi
  fi
  
  # If the package still isn't found
  if [ ! -f "$PACKAGE_FILE_EXT" ]; then
    echo "  From the web (libs repository)"
    
    # Download the package from the web
  	wget -q "https://github.com/$REPOSITORY_OWNER/libs/raw/master/$PACKAGE_FILE.zip" -O $PACKAGE_FILE_EXT || exit 1

    # Unzip the package
	  unzip -qq -o "$PACKAGE_FILE_EXT" -d "$PACKAGE_FOLDER/" || exit 1
	  
	  if [ $IS_IN_INDEX ]; then
      # Make the GrowSense index lib directory if necessary
	    mkdir -p $INDEX_LIB_DIR
	    
	    # Copy the package into the GrowSense index lib directory
	    cp -r "$PACKAGE_FOLDER" $INDEX_LIB_DIR/$PACKAGE_FOLDER_WITH_VERSION/ || exit 1
      cp -r $PACKAGE_FILE_EXT $INDEX_LIB_DIR/$PACKAGE_FILE_EXT || exit 1
	  fi
  fi
	
else
	echo "  Already exists. Skipping download."
fi


