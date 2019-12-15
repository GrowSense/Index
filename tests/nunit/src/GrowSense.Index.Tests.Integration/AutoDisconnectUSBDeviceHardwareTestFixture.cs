using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;
using System.IO;

namespace GrowSense.Index.Tests.Integration
{
  [TestFixture (Category = "Integration")]
  public class AutoDisconnectUSBDeviceHardwareTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_AutoDisconnectDevice ()
    {
      var deviceInfo = new DeviceInfo ();
      deviceInfo.FamilyName = "GrowSense";
      deviceInfo.DeviceName = "irrigator1";
      deviceInfo.GroupName = "irrigator";
      deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
      deviceInfo.BoardType = "uno";
      deviceInfo.Port = "/dev/ttyUSB0";//GetIrrigatorPort ();

      using (var helper = new AutoDisconnectUSBDeviceHardwareTestHelper (ProjectDirectory)) {
        helper.ExampleDevice = deviceInfo;
        helper.TestDisconnectDevice ();
      }
    }
  }
}

