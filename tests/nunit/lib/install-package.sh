#!/bin/bash

PACKAGE_NAME=$1
PACKAGE_VERSION=$2

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
PACKAGE_FILE_EXT="$PACKAGE_NAME.$PACKAGE_VERSION.nupkg"

#echo "  Package file: $PACKAGE_FILE"

# If the package isn't found
if [ ! -d "$PACKAGE_FILE" ]; then

  # Check if the project exists within the GreenSense index
	[[ $(echo $PWD) =~ "GreenSense/Index" ]] && IS_IN_INDEX=1 || IS_IN_INDEX=0
	
	if [ $IS_IN_INDEX ]; then
	  # Get the path to the GreenSense index lib directory
	  INDEX_LIB_DIR=$(readlink -f "../../../lib")
	  
	  #echo "  GreenSense index lib directory:"
	  #echo "    $INDEX_LIB_DIR"
	  
	  # Check if the package exists in the GreenSense inject lib directory
    if [ -d "$INDEX_LIB_DIR/$PACKAGE_FILE" ]; then
      echo "  From GreenSense index lib directory"
      # Copy the package from the GreenSense index lib directory
      cp -r $INDEX_LIB_DIR/$PACKAGE_FILE $PACKAGE_NAME || exit 1
    fi
  fi
  
  # If the package still isn't found
  if [ ! -d "$PACKAGE_NAME" ]; then
    echo "  From the web"
    
    # Download the package from the web
  	wget -q "https://github.com/GreenSense/libs/raw/master/$PACKAGE_FILE.nupkg" -O $PACKAGE_FILE_EXT || exit 1

    # Unzip the package
	  unzip -qq -o "$PACKAGE_FILE_EXT" -d "$PACKAGE_NAME/" || exit 1
	  
	  if [ $IS_IN_INDEX ]; then
      # Make the GreenSense index lib directory if necessary
	    mkdir -p $INDEX_LIB_DIR
	    
	    # Copy the package into the GreenSense index lib directory
	    cp -r "$PACKAGE_NAME" $INDEX_LIB_DIR/$PACKAGE_FILE/ || exit 1
	  fi
  fi
	
else
	echo "  Already exists. Skipping download."
fi


