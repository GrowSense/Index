docker run -it --rm -v $PWD:/project-src -v /var/run/docker.sock:/var/run/docker.sock arm32v7/ubuntu:trusty /bin/bash -c "apt-get update && apt-get install -y rsync && rsync -av --exclude='.git' /project-src/* /project-dest && cd /project-dest && sh init-mock-setup.sh && sh prepare.sh && sh init.sh && sh build.sh"
# 
# 
