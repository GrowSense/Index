using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;
using System.IO;

namespace GreenSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class AutoRemoveDeviceHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_AutoRemoveDevice ()
        {

            var starter = GetTestProcessStarter (false);
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

            var cmd = String.Format ("sh auto-remove-device.sh {0}",
                          deviceInfo.Port.Replace ("/dev/", "")
                      );

            starter.RunBash (cmd);

            Assert.IsFalse (starter.Starter.IsError);

            var expectedText = "Garden device removed: " + deviceName;

            Assert.IsTrue (starter.Starter.Output.Contains (expectedText));
        }

        public void CreateExampleDevice (string deviceName, DeviceInfo deviceInfo)
        {
            var devicesDir = Path.GetFullPath ("devices");

            if (!Directory.Exists (devicesDir))
                Directory.CreateDirectory (devicesDir);

            var deviceDir = Path.Combine (devicesDir, deviceName);

            if (!Directory.Exists (deviceDir))
                Directory.CreateDirectory (deviceDir);

            var deviceNameFile = Path.Combine (deviceDir, "name.txt");

            File.WriteAllText (deviceNameFile, deviceName);

            var portFile = Path.Combine (deviceDir, "port.txt");

            File.WriteAllText (portFile, deviceInfo.Port.Replace ("/dev/", ""));
        }
    }
}

