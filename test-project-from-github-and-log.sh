#!/bin/bash

echo ""
echo "Starting test of GrowSense project"
echo ""

echo "Project number: $1"
echo "Project path: $2"
echo "Branch: $3"

# The username is hard coded to work with cron. This can be commented out to auto-detect the user.
USER=j

WORKSPACE_PATH=/home/$USER/workspace
#WORKSPACE_PATH=/media/$USER/store/workspace

GREENSENSE_INDEX_PATH="$WORKSPACE_PATH/GrowSense/Index"

TIMESTAMP=$(date +"%Y_%m_%d_%I_%M_%p")

PROJECT_NUMBER="$1"
PROJECT_NAME=$(basename $2)
PROJECT_BRANCH="$3"
echo "Project name: $PROJECT_NAME"
echo "Git branch: $PROJECT_BRANCH"
PROJECT_PATH="$GREENSENSE_INDEX_PATH/$2"
PROJECT_LOGS_PATH="$PROJECT_PATH/logs/$PROJECT_BRANCH"
PROJECT_LOG_PATH="$PROJECT_LOGS_PATH/$TIMESTAMP.log"
PROJECT_GIT_URL="https://raw.githubusercontent.com/GrowSense/$PROJECT_NAME"
mkdir -p $PROJECT_LOGS_PATH
echo "Logging to: $PROJECT_LOG_PATH"

echo ""
PROJECT_LOGS_PUBLISH_PATH="$GREENSENSE_INDEX_PATH/public/test-results/$PROJECT_NAME/$PROJECT_BRANCH"
echo "Publishing results to: $PROJECT_LOGS_PUBLISH_PATH"
mkdir -p $PROJECT_LOGS_PUBLISH_PATH

echo ""
echo "Git URL: $PROJECT_GIT_URL"

echo ""
echo "Getting project test script from git..."
echo ""

# TODO: Remove or reimplement. This should be obsolete because the test script can auto-detect what ports to use
#echo "Choosing test script based on project number: $PROJECT_NUMBER"

SCRIPT_NAME="test-from-github.sh"

# TODO: Remove or reimplement. This should be obsolete because the test script can auto-detect what ports to use
#if [ "$PROJECT_NUMBER" -eq "2" ];
#then
#  echo "This project is the second pair. Choosing second pair script so it uses the right ports."
#  SCRIPT_NAME="test-from-github-as-second-pair.sh"
#fi

# The following alternative is used for testing purposes but disabled by default
#SCRIPT_NAME="test-via-docker-from-github-mock-success.sh"

echo "Script name:"
echo "  $SCRIPT_NAME"

SCRIPT_URL="$PROJECT_GIT_URL/$PROJECT_BRANCH/$SCRIPT_NAME"
echo "Script URL:"
echo "  $SCRIPT_URL"

# Tail -f the latest log to the public directory as it's produced
LATEST_LOG_PATH="$PROJECT_LOGS_PUBLISH_PATH/latest.log"
echo "Latest log file:"
echo "  $LATEST_LOG_PATH"

# Get the script and run it
curl -H 'Cache-Control: no-cache' -s $SCRIPT_URL | bash -s $PROJECT_BRANCH > $LATEST_LOG_PATH 2>&1

# Check the output
ANALYSE_SCRIPT_URL="https://raw.githubusercontent.com/GrowSense/Index/$PROJECT_BRANCH/analyse-test-log.sh"

echo ""
echo "Getting analysis script from git..."
echo ""

curl -H 'Cache-Control: no-cache' -s $ANALYSE_SCRIPT_URL | bash -s $PROJECT_LOG_PATH

# Publish results
echo "Publishing results to: $PROJECT_LOGS_PUBLISH_PATH"
cp $PROJECT_LOGS_PATH/status.txt $PROJECT_LOGS_PUBLISH_PATH
cp $PROJECT_LOGS_PATH/summary.log $PROJECT_LOGS_PUBLISH_PATH
cp $LATEST_LOG_PATH $PROJECT_LOG_PATH
cp $PROJECT_LOG_PATH $PROJECT_LOGS_PUBLISH_PATH


echo ""
echo "Finished test of GrowSense project"
echo ""
