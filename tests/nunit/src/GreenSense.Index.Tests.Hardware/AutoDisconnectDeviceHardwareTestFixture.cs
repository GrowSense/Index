using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;
using System.IO;

namespace GreenSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class AutoDisconnectDeviceHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_AutoDisconnectDevice ()
        {
            var deviceInfo = new DeviceInfo ();
            deviceInfo.FamilyName = "GreenSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = GetIrrigatorPort ();

            using (var helper = new AutoDisconnectDeviceHardwareTestHelper (ProjectDirectory)) {
                helper.ExampleDevice = deviceInfo;
                helper.TestDisconnectDevice ();
            }
            /*var starter = GetTestProcessStarter (false);
            starter.IsMockHardware = false;
            starter.Initialize ();

            var deviceInfo = new DeviceInfo ();
            deviceInfo.FamilyName = "GreenSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = GetIrrigatorPort ();

            var deviceName = "TestDevice1";

            CreateExampleDevice (deviceName, deviceInfo);

            var cmd = String.Format ("sh auto-disconnect-device.sh {0}",
                          deviceInfo.Port.Replace ("/dev/", "")
                      );

            starter.RunBash (cmd);

            Assert.IsFalse (starter.Starter.IsError);

            var expectedText = "Garden device removed: " + deviceName;

            Assert.IsTrue (starter.Starter.Output.Contains (expectedText));*/
        }

    }
}

