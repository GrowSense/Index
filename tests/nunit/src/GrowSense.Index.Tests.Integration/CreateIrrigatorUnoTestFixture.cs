using System;
using NUnit.Framework;

namespace GrowSense.Index.Tests.Integration
{
    [TestFixture (Category = "Integration")]
    public class CreateIrrigatorUnoTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateIrrigatorUnoScript ()
        {
            var scriptName = "create-garden-irrigator-uno.sh";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            var deviceBoard = "uno";
            var deviceGroup = "irrigator";
            var deviceProject = "SoilMoistureSensorCalibratedPump";
            var deviceLabel = "TestIrrigator";
            var deviceName = "testIrrigator";
            var devicePort = "ttyUSB1";

            var arguments = deviceLabel + " " + deviceName + " " + devicePort;

            var starter = GetTestProcessStarter ();
            starter.RunBash ("sh " + scriptName + " " + arguments);

            CheckDeviceInfoWasCreated (deviceBoard, deviceGroup, deviceProject, deviceLabel, deviceName, devicePort);

            // Disabled because the UI is created by the supervisor script now
            //CheckDeviceUIWasCreated (deviceLabel, deviceName, "Soil Moisture", "C");

            CheckMqttBridgeServiceFileWasCreated (deviceName);
        }
    }
}
