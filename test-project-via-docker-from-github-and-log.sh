#!/bin/bash

echo "Project: $1"

# The username is hard coded to work with cron. This can be commented out to auto-detect the user.
USER=j

WORKSPACE_PATH=/home/$USER/workspace
#WORKSPACE_PATH=/media/$USER/store/workspace

GREENSENSE_INDEX_PATH="$WORKSPACE_PATH/GreenSense/Index"

TIMESTAMP=$(date +"%Y_%m_%d_%I_%M_%p")
echo "Testing $1"

PROJECT_NAME=$(basename $1)
echo "Project name: $PROJECT_NAME"
PROJECT_PATH="$GREENSENSE_INDEX_PATH/$1"
PROJECT_LOGS_PATH="$PROJECT_PATH/logs"
PROJECT_LOG_PATH="$PROJECT_LOGS_PATH/$TIMESTAMP.log"
PROJECT_GIT_URL="https://raw.githubusercontent.com/GreenSense/$PROJECT_NAME"
mkdir -p $PROJECT_LOGS_PATH
echo "Logging to: $PROJECT_LOG_PATH"
echo "Git URL: $PROJECT_GIT_URL"

# Get the script and run it
curl -s $PROJECT_GIT_URL/master/test-via-docker-from-github.sh | bash > $PROJECT_LOG_PATH 2>&1

# Check the output
ANALYSE_SCRIPT_URL="https://raw.githubusercontent.com/GreenSense/Index/master/test-project-via-docker-from-github-and-log.sh"

curl $ANALYSE_SCRIPT_URL | bash -s $PROJECT_LOG_PATH 2>&1

# Publish results
PROJECT_LOGS_PUBLISH_PATH="$GREENSENSE_INDEX_PATH/public/test-results/$PROJECT_NAME/"
mkdir -p $PROJECT_LOGS_PUBLISH_PATH
echo "Publishing results to: $PROJECT_LOGS_PUBLISH_PATH"
cp $PROJECT_LOGS_PATH/* $PROJECT_LOGS_PUBLISH_PATH
