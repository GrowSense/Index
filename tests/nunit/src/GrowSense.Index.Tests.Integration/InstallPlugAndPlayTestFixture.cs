using System;
using NUnit.Framework;

namespace GrowSense.Index.Tests.Integration
{
    [TestFixture]
    public class InstallPlugAndPlayTestFixture : BaseTestFixture
    {

        [Test]
        public void Test_CreateIrrigatorNanoScript ()
        {
            var scriptName = "install-plug-and-play.sh";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            var deviceBoard = "nano";
            var deviceGroup = "irrigator";
            var deviceProject = "SoilMoistureSensorCalibratedPump";
            var deviceLabel = "MyIrrigator";
            var deviceName = "myIrrigator";
            var devicePort = "ttyUSB1";

            var arguments = deviceLabel + " " + deviceName + " " + devicePort;

            var starter = GetTestProcessStarter ();
            starter.RunBash ("sh " + scriptName + " " + arguments);

            /* CheckDeviceInfoWasCreated (deviceBoard, deviceGroup, deviceProject, deviceLabel, deviceName, devicePort);

            CheckDeviceUIWasCreated (deviceLabel, deviceName, "Soil Moisture", "C");

            CheckMqttBridgeServiceFileWasCreated (deviceName);

            CheckUpdaterServiceFileWasCreated (deviceName);*/
        }
    }
}

