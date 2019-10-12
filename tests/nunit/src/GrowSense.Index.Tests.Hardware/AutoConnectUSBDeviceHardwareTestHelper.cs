using System;
using ArduinoPlugAndPlay;
using NUnit.Framework;
using System.Collections.Generic;

namespace GrowSense.Index.Tests.Hardware
{
    public class AutoConnectUSBDeviceHardwareTestHelper : BaseTestHelper
    {
        public List<DeviceInfo> Devices = new List<DeviceInfo> ();

        public AutoConnectUSBDeviceHardwareTestHelper (string projectDirectory) : base (projectDirectory)
        {
        }

        public void TestConnectDevice ()
        {
            if (Devices.Count == 0)
                Assert.Fail ("No devices added to test helper.");

            var starter = GetTestProcessStarter (false);
            //starter.IsMockHardware = false;
            starter.Initialize ();

            int i = 0;

            foreach (var deviceInfo in Devices) {
                i++;
                var cmd = String.Format ("sh auto-connect-usb-device.sh {0} {1} {2} {3} {4} {5}",
                              deviceInfo.BoardType,
                              deviceInfo.FamilyName,
                              deviceInfo.GroupName,
                              deviceInfo.ProjectName,
                              deviceInfo.ScriptCode,
                              deviceInfo.Port.Replace ("/dev/", "")
                          );

                Console.WriteLine ("");
                Console.WriteLine ("Adding device #" + i + "...");

                starter.RunBash (cmd);

                Assert.IsFalse (starter.Starter.IsError, "An error occurred running the bash command.");

                int deviceNumber = 1; // Always 1 when there's only one of each device. Each type is numbered separately.

                var expectedText = "Garden " + deviceInfo.GroupName + " created with device name '" + deviceInfo.GroupName + deviceNumber + "'";

                Assert.IsTrue (starter.Starter.Output.Contains (expectedText), "Expected text wasn't found: " + expectedText);
            }
        }
    }
}

