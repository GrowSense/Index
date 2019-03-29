using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;

namespace GreenSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class AutoConnectDeviceHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_AutoConnectDevices ()
        {
            var deviceInfo = new DeviceInfo ();
            deviceInfo.FamilyName = "GreenSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = GetIrrigatorPort ();

            var deviceInfo2 = new DeviceInfo ();
            deviceInfo2.FamilyName = "GreenSense";
            deviceInfo2.GroupName = "illuminator";
            deviceInfo2.ProjectName = "LightPRSensorCalibratedLight";
            deviceInfo2.BoardType = "uno";
            deviceInfo2.Port = GetIlluminatorPort ();

            var deviceInfo3 = new DeviceInfo ();
            deviceInfo3.FamilyName = "GreenSense";
            deviceInfo3.GroupName = "ventilator";
            deviceInfo3.ProjectName = "TemperatureHumidityDHTSensorFan";
            deviceInfo3.BoardType = "uno";
            deviceInfo3.Port = GetVentilatorPort ();

            var deviceInfo4 = new DeviceInfo ();
            deviceInfo4.FamilyName = "GreenSense";
            deviceInfo4.GroupName = "irrigator";
            deviceInfo4.ProjectName = "SoilMoistureSensorCalibratedPumpESP";
            deviceInfo4.BoardType = "esp";
            deviceInfo4.Port = GetIrrigatorESPPort ();

            using (var helper = new AutoConnectDeviceHardwareTestHelper (ProjectDirectory)) {
                helper.Devices.Add (deviceInfo);
                //helper.Devices.Add (deviceInfo2);
                //helper.Devices.Add (deviceInfo3);
                //helper.Devices.Add (deviceInfo4);
                helper.TestConnectDevice ();
            }
        }
    }
}

