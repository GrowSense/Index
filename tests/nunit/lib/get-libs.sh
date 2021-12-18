echo "Getting library files..."
echo "  Dir: $PWD"

bash install-package-from-libs-repository.sh GrowSense NUnit 2.6.4 || exit 1
bash install-package-from-libs-repository.sh GrowSense NUnit.Runners 2.6.4 || exit 1
bash install-package-from-libs-repository.sh GrowSense Newtonsoft.Json 11.0.2 || exit 1

bash install-package-from-github-release.sh CompulsiveCoder ArduinoPlugAndPlay 1.0.2.55 || exit 1

echo "  Listing libs contents..."
ls -al

echo "Finished getting library files."
