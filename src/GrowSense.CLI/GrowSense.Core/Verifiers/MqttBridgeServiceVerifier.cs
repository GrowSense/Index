using System;
using GrowSense.Core.Tools;
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
      
      var status = SystemCtl.Status("growsense-mqtt-bridge-" + deviceName + ".service");

      if (status != SystemCtlServiceStatus.Active)
        throw new Exception("MQTT bridge service is not running for: " + deviceName);

      Console.WriteLine("Finished verifying MQTT bridge service is active.");
    }
  }
}
