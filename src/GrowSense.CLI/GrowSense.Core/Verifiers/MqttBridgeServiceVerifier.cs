using System;
using GrowSense.Core.Tools;
using System.Threading;
namespace GrowSense.Core.Verifiers
{
  public class MqttBridgeServiceVerifier
  {
    public SystemCtlHelper SystemCtl;
    
    public MqttBridgeServiceVerifier(CLIContext context)
    {
      SystemCtl = new SystemCtlHelper(context);
    }

    public void Verify(string deviceName)
    {
      Console.WriteLine("Verifying MQTT bridge service is active...");
      Console.WriteLine("  Device name: " + deviceName);

      var attempt = 1;
      var isFinished = false;

      var status = SystemCtlServiceStatus.NotSet;

      while (!isFinished)
      {
        status = SystemCtl.Status("growsense-mqtt-bridge-" + deviceName + ".service");

        attempt++;

        if (attempt > 10 || status == SystemCtlServiceStatus.Active)
          isFinished = true;
        else
          Thread.Sleep(1000);
      }
      
      if (status != SystemCtlServiceStatus.Active)
        throw new Exception("MQTT bridge service is not running for: " + deviceName);

      Console.WriteLine("Finished verifying MQTT bridge service is active.");
    }
  }
}
