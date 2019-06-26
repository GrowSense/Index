echo "Getting library files..."
echo "  Dir: $PWD"

bash install-package.sh NUnit 2.6.4
bash install-package.sh NUnit.Runners 2.6.4
bash install-package.sh Newtonsoft.Json 11.0.2
bash install-package.sh ArduinoPlugAndPlay 1.0.0.195 

echo "Finished getting library files."
