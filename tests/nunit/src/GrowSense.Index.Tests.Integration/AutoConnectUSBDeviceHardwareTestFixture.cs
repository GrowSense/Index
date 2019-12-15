using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;

namespace GrowSense.Index.Tests.Integration
{
  [TestFixture (Category = "Integration")]
  public class AutoConnectUSBDeviceHardwareTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_AutoConnectDevices ()
    {
      var deviceInfo = new DeviceInfo ();
      deviceInfo.FamilyName = "GrowSense";
      deviceInfo.GroupName = "irrigator";
      deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
      deviceInfo.BoardType = "uno";
      deviceInfo.DeviceName = "irrigator1";
      deviceInfo.ScriptCode = "irrigator";
      deviceInfo.Port = "/dev/ttyUSB0";//GetIrrigatorPort ();

      var deviceInfo2 = new DeviceInfo ();
      deviceInfo2.FamilyName = "GrowSense";
      deviceInfo2.GroupName = "illuminator";
      deviceInfo2.ProjectName = "LightPRSensorCalibratedLight";
      deviceInfo2.BoardType = "uno";
      deviceInfo2.DeviceName = "illuminator1";
      deviceInfo2.ScriptCode = "illuminator";
      deviceInfo2.Port = "/dev/ttyUSB1";//GetIlluminatorPort ();

      var deviceInfo3 = new DeviceInfo ();
      deviceInfo3.FamilyName = "GrowSense";
      deviceInfo3.GroupName = "ventilator";
      deviceInfo3.ProjectName = "TemperatureHumidityDHTSensorFan";
      deviceInfo3.BoardType = "uno";
      deviceInfo3.DeviceName = "ventilator1";
      deviceInfo3.ScriptCode = "ventilator";
      deviceInfo3.Port = "/dev/ttyUSB2";//GetVentilatorPort ();

      var deviceInfo4 = new DeviceInfo ();
      deviceInfo4.FamilyName = "GrowSense";
      deviceInfo4.GroupName = "irrigator";
      deviceInfo4.ProjectName = "SoilMoistureSensorCalibratedPumpESP";
      deviceInfo4.BoardType = "esp";
      deviceInfo4.DeviceName = "irrigator2";
      deviceInfo4.ScriptCode = "irrigator";
      deviceInfo4.Port = "/dev/ttyUSB3";//GetIrrigatorESPPort ();

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

