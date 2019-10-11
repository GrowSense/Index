using System;
using NUnit.Framework;

namespace GrowSense.Index.Tests.Integration
{
    [TestFixture (Category = "Integration")]
    public class CreateVentilatorNanoTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateVentilatorNanoScript ()
        {
            var scriptName = "create-garden-ventilator-nano.sh";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            var deviceBoard = "nano";
            var deviceGroup = "ventilator";
            var deviceProject = "TemperatureHumidityDHTSensorFan";
            var deviceLabel = "MyVentilator";
            var deviceName = "myVentilator";
            var devicePort = "ttyUSB1";

            var arguments = deviceLabel + " " + deviceName + " " + devicePort;

            var starter = GetTestProcessStarter ();
            starter.RunBash ("sh " + scriptName + " " + arguments);

            CheckDeviceInfoWasCreated (deviceBoard, deviceGroup, deviceProject, deviceLabel, deviceName, devicePort);

            // Disabled because the UI is created by the supervisor script now
            //CheckDeviceUIWasCreated (deviceLabel, deviceName, "Ventilator1", "A", "Temperature", "T");

            CheckMqttBridgeServiceFileWasCreated (deviceName);
        }
    }
}
