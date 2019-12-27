using System;
using NUnit.Framework;
using System.Threading;

namespace GrowSense.Index.Tests.Integration
{
  [TestFixture (Category = "Integration")]
  public class CreateIrrigatorNanoTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_CreateIrrigatorNanoScript ()
    {
      var scriptName = "create-garden-irrigator-nano.sh";

      Console.WriteLine ("Script:");
      Console.WriteLine (scriptName);

      var deviceBoard = "nano";
      var deviceGroup = "irrigator";
      var deviceProject = "SoilMoistureSensorCalibratedPump";
      var deviceLabel = "MyIrrigator";
      var deviceName = "myIrrigator";
      var devicePort = "ttyUSB1";

      var arguments = deviceLabel + " " + deviceName + " " + devicePort;

      var starter = GetTestProcessStarter ();
      starter.RunBash ("sh " + scriptName + " " + arguments);
      
      Thread.Sleep (1000);

      Assert.IsFalse (starter.Starter.IsError, "An error occurred running the script.");
      
      CheckDeviceInfoWasCreated (deviceBoard, deviceGroup, deviceProject, deviceLabel, deviceName, devicePort);

      CheckMqttBridgeServiceFileWasCreated (deviceName);
    }
  }
}
