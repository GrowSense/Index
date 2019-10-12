
using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests.Integration
{
    [TestFixture (Category = "Integration")]
    public class CreateGardenTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateGardenScript ()
        {
            var scriptName = "create-garden";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            Console.WriteLine ("Running create-garden script");

            var starter = GetTestProcessStarter ();
            var output = starter.RunScript (scriptName);

            var successfulText = "Setup complete";

            Assert.IsTrue (output.Contains (successfulText), "Script output doesn't contain the text: " + successfulText);

            var serviceFileName = "greensense-mosquitto-docker.service";

            CheckServiceExists (serviceFileName);
        }

        public void CheckServiceExists (string serviceFileName)
        {
            if (!serviceFileName.EndsWith (".service"))
                serviceFileName += ".service";

            var serviceFilePath = Path.Combine (GetServicesDirectory (), serviceFileName);

            Console.WriteLine ("Checking mosquitto service file exists...");
            Console.WriteLine ("  " + serviceFilePath);

            var serviceFileExists = File.Exists (serviceFilePath);

            Assert.IsTrue (serviceFileExists, "Service file not found: " + serviceFilePath);
        }
    }
}
