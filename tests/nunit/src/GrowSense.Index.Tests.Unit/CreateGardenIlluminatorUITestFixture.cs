using System;
using NUnit.Framework;
using System.IO;
using Newtonsoft.Json.Linq;

namespace GrowSense.Index.Tests.Unit
{
    [TestFixture (Category = "Unit")]
    public class CreateGardenIlluminatorUITestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateGardenIlluminatorUI ()
        {
            var scriptName = "create-garden-illuminator-ui.sh";

            Console.WriteLine ("Testing " + scriptName + " script");

            var deviceLabel = "Illuminator1";
            var deviceName = "testIlluminator1";

            var arguments = deviceLabel + " " + deviceName;

            var command = "sh " + scriptName + " " + arguments;

            var starter = GetTestProcessStarter ();

            Console.WriteLine ("Running script...");

            starter.RunBash (command);

            Console.WriteLine ("Checking device UI was created...");

            CheckDeviceUIWasCreated (deviceLabel, deviceName, "Light", "L");

            Console.WriteLine ("Creating device info folder...");

            Directory.CreateDirectory (Path.GetFullPath ("devices/" + deviceName));

            Console.WriteLine ("Attempting to create a duplicate...");

            starter.RunBash (command);

            Console.WriteLine ("Ensuring that no duplicate UI was created...");

            CheckDeviceUICount (1);
        }
    }
}
