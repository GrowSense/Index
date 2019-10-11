using System;
using System.Collections.Generic;
using ArduinoPlugAndPlay;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests.Hardware
{
    public class AutoDisconnectUSBDeviceHardwareTestHelper : BaseTestHelper
    {
        public DeviceInfo ExampleDevice;

        public AutoDisconnectUSBDeviceHardwareTestHelper (string projectDirectory) : base (projectDirectory)
        {
        }

        public void TestDisconnectDevice ()
        {

            var starter = GetTestProcessStarter (false);
            starter.IsMockHardware = false;
            starter.Initialize ();

            var deviceInfo = ExampleDevice;

            var deviceName = "testIrrigator1";

            CreateExampleDevice (deviceName, deviceInfo);

            var cmd = String.Format ("sh auto-disconnect-usb-device.sh {0}",
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

            var boardFile = Path.Combine (deviceDir, "board.txt");

            File.WriteAllText (boardFile, deviceInfo.BoardType);

            var group = Path.Combine (deviceDir, "group.txt");

            File.WriteAllText (boardFile, deviceInfo.GroupName);
        }
    }
}

