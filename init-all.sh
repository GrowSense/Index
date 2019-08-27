echo "Initializing entire GreenSense index and all submodules"

sh clean-all.sh && \

sh init.sh && \
sh init-apps.sh && \
sh init-tests.sh && \
sh init-submodules.sh && \

echo "Finished initializing entire GreenSense index and all submodules"
