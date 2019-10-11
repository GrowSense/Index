echo "Initializing entire GrowSense index and all submodules"

sh clean-all.sh && \

sh init.sh && \
sh init-apps.sh && \
sh init-tests.sh && \
sh init-submodules.sh && \

echo "Finished initializing entire GrowSense index and all submodules"
