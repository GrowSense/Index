using System;
using NUnit.Framework;

namespace GrowSense.Index.Tests.Integration
{
  [TestFixture (Category = "Integration")]
  public class CreateMonitorUnoTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_CreateMonitorUnoScript ()
    {
      var scriptName = "create-garden-monitor-uno.sh";

      Console.WriteLine ("Script:");
      Console.WriteLine (scriptName);

      var deviceBoard = "uno";
      var deviceGroup = "monitor";
      var deviceProject = "SoilMoistureSensorCalibratedSerial";
      var deviceLabel = "MyMonitor1";
      var deviceName = "myMonitor1";
      var devicePort = "ttyUSB0";

      var arguments = deviceLabel + " " + deviceName + " " + devicePort;

      var starter = GetTestProcessStarter ();
      starter.RunBash ("sh " + scriptName + " " + arguments);

      Assert.IsFalse (starter.Starter.IsError, "An error occurred running the script.");
      
      CheckDeviceInfoWasCreated (deviceBoard, deviceGroup, deviceProject, deviceLabel, deviceName, devicePort);

      CheckMqttBridgeServiceFileWasCreated (deviceName);
    }
  }
}
