#!/bin/bash

PACKAGE_OWNER=$1
PACKAGE_NAME=$2
PACKAGE_VERSION=$3
INCLUDE_VERSION_IN_FOLDER=$4

if [ ! "$PACKAGE_OWNER" ]; then
	echo "Please provide a package owner as an argument."
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

INCLUDE_VERSION_IN_FOLDER="false"

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "Installing package $PACKAGE_NAME $PACKAGE_VERSION..."

POSTFIX=""

if [ "$BRANCH" != "lts" ]; then
  POSTFIX="-$BRANCH"
fi

PACKAGE_FILE="$PACKAGE_NAME.$PACKAGE_VERSION"
PACKAGE_FILE_EXT="$PACKAGE_NAME.$PACKAGE_VERSION$POSTFIX.zip"

PACKAGE_FOLDER_WITH_VERSION="$PACKAGE_NAME.$PACKAGE_VERSION$POSTFIX"
PACKAGE_FOLDER="$PACKAGE_NAME"

#echo "  Package name: $PACKAGE_NAME"
#echo "  Package version: $PACKAGE_VERSION"
#echo "  Package file: $PACKAGE_FILE"
#echo "  Package file with extention: $PACKAGE_FILE_EXT"
#echo "  Package folder: $PACKAGE_FOLDER"
#echo "  Include version in folder: $INCLUDE_VERSION_IN_FOLDER"

if [ "$INCLUDE_VERSION_IN_FOLDER" = "true" ]; then
  PACKAGE_FOLDER="$PACKAGE_FOLDER_WITH_VERSION"
fi

# If the package isn't found
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
  if [ ! -d "$PACKAGE_NAME" ]; then
    echo "  From the web (GitHub release)"
    
    # Download the package from the web    
  	wget -q https://github.com/$PACKAGE_OWNER/$PACKAGE_NAME/releases/download/v$PACKAGE_VERSION$POSTFIX/$PACKAGE_NAME.$PACKAGE_VERSION$POSTFIX.zip -O $PACKAGE_FILE_EXT || exit 1

    # Unzip the package
	  unzip -qq -o "$PACKAGE_FILE_EXT" -d "$PACKAGE_FOLDER/" || exit 1
	  
	  if [ $IS_IN_INDEX ]; then
      # Make the GrowSense index lib directory if necessary
	    mkdir -p $INDEX_LIB_DIR
	    
	    # Copy the package into the GrowSense index lib directory
	    cp -r "$PACKAGE_NAME" $INDEX_LIB_DIR/$PACKAGE_FOLDER_WITH_VERSION/ || exit 1
	    cp -r "$PACKAGE_FILE_EXT" $INDEX_LIB_DIR/$PACKAGE_FILE_EXT || exit 1
	  fi
  fi
	
else
	echo "  Already exists. Skipping download."
fi


