using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;

namespace GrowSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class AutoConnectUSBDeviceHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_AutoConnectDevices ()
        {
            var deviceInfo = new DeviceInfo ();
            deviceInfo.FamilyName = "GrowSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.ScriptCode = "irrigator";
            deviceInfo.Port = GetIrrigatorPort ();

            var deviceInfo2 = new DeviceInfo ();
            deviceInfo2.FamilyName = "GrowSense";
            deviceInfo2.GroupName = "illuminator";
            deviceInfo2.ProjectName = "LightPRSensorCalibratedLight";
            deviceInfo2.BoardType = "uno";
            deviceInfo2.ScriptCode = "illuminator";
            deviceInfo2.Port = GetIlluminatorPort ();

            var deviceInfo3 = new DeviceInfo ();
            deviceInfo3.FamilyName = "GrowSense";
            deviceInfo3.GroupName = "ventilator";
            deviceInfo3.ProjectName = "TemperatureHumidityDHTSensorFan";
            deviceInfo3.BoardType = "uno";
            deviceInfo3.ScriptCode = "ventilator";
            deviceInfo3.Port = GetVentilatorPort ();

            var deviceInfo4 = new DeviceInfo ();
            deviceInfo4.FamilyName = "GrowSense";
            deviceInfo4.GroupName = "irrigator";
            deviceInfo4.ProjectName = "SoilMoistureSensorCalibratedPumpESP";
            deviceInfo4.BoardType = "esp";
            deviceInfo4.ScriptCode = "irrigator";
            deviceInfo4.Port = GetIrrigatorESPPort ();

            using (var helper = new AutoConnectUSBDeviceHardwareTestHelper (ProjectDirectory)) {
                helper.Devices.Add (deviceInfo);
                helper.Devices.Add (deviceInfo2);
                helper.Devices.Add (deviceInfo3);
                helper.Devices.Add (deviceInfo4);
                helper.TestConnectDevice ();
            }
        }
    }
}

