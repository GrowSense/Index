echo "Getting library files..."
echo "  Dir: $PWD"


# Nuget is disabled because it's not currently required
#sh get-nuget.sh
#sh nuget-update-self.sh

sh nuget-install.sh NUnit 2.6.4
sh nuget-install.sh NUnit.Runners 2.6.4
sh nuget-install.sh Newtonsoft.Json 11.0.2

echo "Finished getting library files."
