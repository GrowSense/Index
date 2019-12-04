bash cache-repository.sh && \
bash bash upgrade-garden-device-sketches.sh && \
bash run-background.sh bash upgrade-system.sh >> logs/updates/system.txt # Run this in the background so it's not stopped during upgrade
