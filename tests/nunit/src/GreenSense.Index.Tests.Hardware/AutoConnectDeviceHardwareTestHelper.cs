using System;
using ArduinoPlugAndPlay;
using NUnit.Framework;
using System.Collections.Generic;

namespace GreenSense.Index.Tests.Hardware
{
    public class AutoConnectDeviceHardwareTestHelper : BaseTestHelper
    {
        public List<DeviceInfo> Devices = new List<DeviceInfo> ();

        public AutoConnectDeviceHardwareTestHelper (string projectDirectory) : base (projectDirectory)
        {
        }

        public void TestConnectDevice ()
        {
            if (Devices.Count == 0)
                Assert.Fail ("No devices added to test helper.");

            var starter = GetTestProcessStarter (false);
            starter.IsMockHardware = false;
            starter.Initialize ();

            int i = 0;

            foreach (var deviceInfo in Devices) {

                i++;
                var cmd = String.Format ("sh auto-connect-device.sh {0} {1} {2} {3} {4}",
                              deviceInfo.BoardType,
                              deviceInfo.FamilyName,
                              deviceInfo.GroupName,
                              deviceInfo.ProjectName,
                              deviceInfo.Port.Replace ("/dev/", "")
                          );

                Console.WriteLine ("");
                Console.WriteLine ("Adding device #" + i + " device...");

                starter.RunBash (cmd);

                Assert.IsFalse (starter.Starter.IsError);

                var expectedText = "Garden " + deviceInfo.GroupName + " created with device name '" + deviceInfo.GroupName + i + "'";

                Assert.IsTrue (starter.Starter.Output.Contains (expectedText));
            }
        }
    }
}

