using System;
using System.Collections.Generic;
using ArduinoPlugAndPlay;
using NUnit.Framework;
using System.IO;

namespace GreenSense.Index.Tests.Hardware
{
    public class AutoDisconnectDeviceHardwareTestHelper : BaseTestHelper
    {
        public DeviceInfo ExampleDevice;

        public AutoDisconnectDeviceHardwareTestHelper (string projectDirectory) : base (projectDirectory)
        {
        }

        public void TestDisconnectDevice ()
        {

            var starter = GetTestProcessStarter (false);
            starter.IsMockHardware = false;
            starter.Initialize ();

            var deviceInfo = ExampleDevice;

            var deviceName = "TestDevice1";

            CreateExampleDevice (deviceName, deviceInfo);

            var cmd = String.Format ("sh auto-disconnect-device.sh {0}",
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

