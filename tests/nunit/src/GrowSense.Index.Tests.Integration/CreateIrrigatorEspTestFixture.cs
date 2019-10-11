using System;
using NUnit.Framework;

namespace GrowSense.Index.Tests.Integration
{
    [TestFixture (Category = "Integration")]
    public class CreateIrrigatorEspTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateIrrigatorEspScript ()
        {
            var scriptName = "create-garden-irrigator-esp.sh";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            var starter = GetTestProcessStarter ();

            var board = "esp";
            var group = "irrigator";
            var project = "SoilMoistureSensorCalibratedPumpESP";
            var label = "MyESPIrrigator";
            var deviceName = "espIrrigator1";
            var port = "ttyUSB1";

            var arguments = label + " " + deviceName + " " + port;

            var output = starter.RunBash ("sh " + scriptName + " " + arguments);

            var successfulText = "Garden ESP/WiFi irrigator created with device name '" + deviceName + "'";

            Assert.IsTrue (output.Contains (successfulText), "Failed. Didn't find expected result text in script output.");

            CheckDeviceInfoWasCreated (board, group, project, label, deviceName, port);

            // Disabled because the UI is created by the supervisor script now
            //CheckDeviceUIWasCreated (label, deviceName, "Soil Moisture", "C");
        }
    }
}
