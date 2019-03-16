using System;
using NUnit.Framework;

namespace GreenSense.Index.Tests.Integration
{
    [TestFixture (Category = "Integration")]
    public class CreateIrrigatorEspTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateIrrigatorEspScript ()
        {
            var scriptName = "test-irrigator-esp";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            var starter = GetTestProcessStarter ();
            var output = starter.RunScript (scriptName);

            var successfulText = "Irrigator ESP8266 test complete";

            Assert.IsTrue (output.Contains (successfulText), "Failed");

            var board = "esp";
            var group = "irrigator";
            var project = "SoilMoistureSensorCalibratedPumpESP";
            var label = "MyIrrigator";
            var name = "myirrigator";
            var port = "ttyUSB1";

            CheckDeviceInfoWasCreated (board, group, project, label, name, port);

            CheckDeviceUIWasCreated (label, name, "Soil Moisture", "C");
        }
    }
}
