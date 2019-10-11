using System;
using NUnit.Framework;

namespace GrowSense.Index.Tests.Integration
{
    [TestFixture (Category = "Integration")]
    public class CreateMonitorNanoTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_CreateMonitorNanoScript ()
        {
            var scriptName = "create-garden-monitor-nano.sh";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            var deviceBoard = "nano";
            var deviceGroup = "monitor";
            var deviceProject = "SoilMoistureSensorCalibratedSerial";
            var deviceLabel = "MyMonitor1";
            var deviceName = "myMonitor1";
            var devicePort = "ttyUSB0";

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
