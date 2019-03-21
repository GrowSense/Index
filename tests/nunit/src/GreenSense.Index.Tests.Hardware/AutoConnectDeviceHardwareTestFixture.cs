using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;

namespace GreenSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class AutoConnectDeviceHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_AutoAddDevice ()
        {
            var deviceInfo = new DeviceInfo ();
            deviceInfo.FamilyName = "GreenSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = GetIrrigatorPort ();

            var deviceInfo2 = new DeviceInfo ();
            deviceInfo2.FamilyName = "GreenSense";
            deviceInfo2.GroupName = "irrigator";
            deviceInfo2.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo2.BoardType = "uno";
            deviceInfo2.Port = GetIlluminatorPort ();

            using (var helper = new AutoConnectDeviceHardwareTestHelper (ProjectDirectory)) {
                helper.Devices.Add (deviceInfo);
                helper.Devices.Add (deviceInfo2);
                helper.TestConnectDevice ();
            }
            /*var starter = GetTestProcessStarter (false);
            starter.IsMockHardware = false;
            starter.Initialize ();


            var cmd = String.Format ("sh auto-add-device.sh {0} {1} {2} {3} {4}",
                          deviceInfo.BoardType,
                          deviceInfo.FamilyName,
                          deviceInfo.GroupName,
                          deviceInfo.ProjectName,
                          deviceInfo.Port.Replace ("/dev/", "")
                      );

            Console.WriteLine ("");
            Console.WriteLine ("Adding a first device...");

            starter.RunBash (cmd);

            Assert.IsFalse (starter.Starter.IsError);

            var expectedText = "Garden " + deviceInfo.GroupName + " created with device name '" + deviceInfo.GroupName + "1'";

            Assert.IsTrue (starter.Starter.Output.Contains (expectedText));

            var cmd2 = String.Format ("sh auto-add-device.sh {0} {1} {2} {3} {4}",
                           deviceInfo2.BoardType,
                           deviceInfo2.FamilyName,
                           deviceInfo2.GroupName,
                           deviceInfo2.ProjectName,
                           deviceInfo2.Port.Replace ("/dev/", "")
                       );

            Console.WriteLine ("");
            Console.WriteLine ("Adding a second device...");

            starter.RunBash (cmd2);

            Assert.IsFalse (starter.Starter.IsError);

            var expectedText2 = "Garden " + deviceInfo2.GroupName + " created with device name '" + deviceInfo2.GroupName + "2'";

            Assert.IsTrue (starter.Starter.Output.Contains (expectedText2));*/
        }
    }
}

