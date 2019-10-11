using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests.Unit
{
    [TestFixture (Category = "Unit")]
    public class CreateDeviceInfoTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateDeviceInfo ()
        {
            var scriptName = "create-device-info.sh";

            Console.WriteLine ("Testing " + scriptName + " script");

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            var deviceBoard = "uno";
            var deviceGroup = "monitor";
            var deviceProject = "SoilMoistureSensorCalibratedSerial";
            var deviceLabel = "Monitor1";
            var deviceName = "monitor1";
            var devicePort = "ttyUSB0";

            var arguments = deviceBoard + " " + deviceGroup + " " + deviceProject + " " + deviceLabel + " " + deviceName + " " + devicePort;

            var command = "sh " + scriptName + " " + arguments;

            var starter = new ProcessStarter ();

            Console.WriteLine ("Running script...");

            starter.Start (command);

            var output = starter.Output;

            Console.WriteLine ("Checking device info was created...");

            CheckDeviceInfoWasCreated (deviceBoard, deviceGroup, deviceProject, deviceLabel, deviceName, devicePort);

            Console.WriteLine ("Checking console output is correct...");

            var successfulText = "Finished creating device info";

            Assert.IsTrue (output.Contains (successfulText), "Failed");

            Console.WriteLine ("Test complete");
        }
    }
}
