expectedVersion=$1

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "Waiting for live deployment to update..."
echo "  Expected version: $1"

isUpToDate=0
attemptCount=1

maxAttempts=10
delayBetweenAttempts=5

if [ $BRANCH == "dev" ]; then
    deploymentHost=$DEPLOY_DEV_LIVE_SSH_HOST
    deploymentUsername=$DEPLOY_DEV_LIVE_SSH_USERNAME
    deploymentPassword=$DEPLOY_DEV_LIVE_SSH_PASSWORD
    deploymentPort=$DEPLOY_DEV_LIVE_SSH_PORT
fi

deploymentFile="deployments/$BRANCH-live.security"

if [ ! $deploymentHost ]; then
  deploymentHost=$(jq -r .Ssh.Host $deploymentFile) 
fi
if [ ! $deploymentUsername ]; then
  deploymentUsername=$(jq -r .Ssh.Username $deploymentFile) 
fi
if [ ! $deploymentPassword ]; then
  deploymentPassword=$(jq -r .Ssh.Password $deploymentFile) 
fi
if [ ! $deploymentPort ]; then
  deploymentPort=$(jq -r .Ssh.Port $deploymentFile) 
fi

if [ ! $deploymentHost ]; then
  echo "  Deployment host not detected."
  exit 1
fi
if [ ! $deploymentUsername ]; then
  echo "  Deployment username not detected."
  exit 1 
fi
if [ ! $deploymentPassword ]; then
  echo "  Deployment password not detected."
  exit 1 
fi
if [ ! $deploymentPort ]; then
  echo "  Deployment port not detected."
  exit 1 
fi

echo "  Deployment..."
echo "    Host: $deploymentHost"
echo "    Username: $deploymentUsername"
echo "    Password: [hidden]"
echo "    Port: $deploymentPort"

while [ $isUpToDate == 0 ] && [ $attemptCount -lt $maxAttempts ];
do
    result=$(sshpass -p $deploymentPassword ssh -o "StrictHostKeyChecking no" $deploymentUsername@$deploymentHost "cd /usr/local/GrowSense/Index; bash gs.sh status")

    echo "$result"

    [[ $(echo $result) =~ "Version: $expectedVersion" ]] && isUpToDate=1

    if [ $isUpToDate == 0 ]; then
        echo "  Sleeping for $delayBetweenAttempts before trying again..."
        sleep $delayBetweenAttempts
    fi
    attemptCount=$((attemptCount+1))
    echo "  Attempt: $attemptCount"
done

echo "  Is up to date: $isUpToDate"


if [ $isUpToDate == 0 ]; then
  echo "  Reached maximum number of attempts. Deployment is not up to date"
  exit 1
fi

echo "Finished waiting for live deployment to update"
