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
        }
    }
}

