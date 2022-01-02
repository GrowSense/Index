echo "Getting library files..."
echo "  Dir: $PWD"

bash install-package-from-libs-repository.sh GrowSense Newtonsoft.Json 11.0.2 || exit 1
bash install-package-from-libs-repository.sh CompulsiveCoder NUnit 2.6.4 || exit 1
bash install-package-from-libs-repository.sh CompulsiveCoder NUnit.Runners 2.6.4 || exit 1
bash install-package-from-github-release.sh CompulsiveCoder ArduinoSerialControllerClient 1.1.1.17 || exit 1

echo "Finished getting library files."
