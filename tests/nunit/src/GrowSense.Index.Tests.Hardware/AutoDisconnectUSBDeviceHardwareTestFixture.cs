using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;
using System.IO;

namespace GrowSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class AutoDisconnectUSBDeviceHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_AutoDisconnectDevice ()
        {
            var deviceInfo = new DeviceInfo ();
            deviceInfo.FamilyName = "GrowSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = GetIrrigatorPort ();

            using (var helper = new AutoDisconnectUSBDeviceHardwareTestHelper (ProjectDirectory)) {
                helper.ExampleDevice = deviceInfo;
                helper.TestDisconnectDevice ();
            }
        }

    }
}

