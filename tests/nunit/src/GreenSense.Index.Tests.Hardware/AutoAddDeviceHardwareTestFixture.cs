using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;

namespace GreenSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class AutoAddDeviceHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_AutoAddDevice ()
        {
            var starter = GetTestProcessStarter (false);
            starter.IsMockHardware = false;
            starter.Initialize ();

            var deviceInfo = new DeviceInfo ();
            deviceInfo.FamilyName = "GreenSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = GetDevicePort ();

            var cmd = String.Format ("sh auto-add-device.sh {0} {1} {2} {3} {4}",
                          deviceInfo.BoardType,
                          deviceInfo.FamilyName,
                          deviceInfo.GroupName,
                          deviceInfo.ProjectName,
                          deviceInfo.Port.Replace ("/dev/", "")
                      );

            starter.RunBash (cmd);

            Assert.IsFalse (starter.Starter.IsError);

            var expectedText = "Garden " + deviceInfo.GroupName + " created with device name '" + deviceInfo.GroupName + "1'";

            Assert.IsTrue (starter.Starter.Output.Contains (expectedText));
        }
    }
}

