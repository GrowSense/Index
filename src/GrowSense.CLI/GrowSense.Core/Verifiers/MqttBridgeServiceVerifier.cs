using System;
using GrowSense.Core.Tools;
using System.Threading;
using GrowSense.Core.Devices;
namespace GrowSense.Core.Verifiers
{
  public class MqttBridgeServiceVerifier
  {
    public SystemCtlHelper SystemCtl;
    public CLIContext Context;
    
    public MqttBridgeServiceVerifier(CLIContext context)
    {
      SystemCtl = new SystemCtlHelper(context);
      Context = context;
    }
    
    public void VerifyDevicesMqttBridgeServices(DeviceInfo[] devices)
    {
      Console.WriteLine("  Verifying devices MQTT bridge services...");

      foreach (var device in devices)
      {
        Console.WriteLine("    Device: " + device.Name);
        Console.WriteLine("      Board: " + device.Board);
        Console.WriteLine("      Host: " + device.Host);
        Console.WriteLine("      Group: " + device.Group);
      
        var isOnThisMachine = device.Host == Context.Settings.HostName;

        var isUSBConnected = device.Board == "nano" || device.Board == "uno";

        var isNotUIDevice = device.Group != "ui";

        var requiresMqttBridge = isOnThisMachine && isUSBConnected && isNotUIDevice;

        Console.WriteLine("      Requires MQTT bridge: " + requiresMqttBridge);

        if (requiresMqttBridge)
          Verify(device.Name);
      }

      Console.WriteLine("  Finished verifying devices MQTT bridge services.");
    }

    public void Verify(string deviceName)
    {
      Console.WriteLine("Verifying MQTT bridge service is active...");
      Console.WriteLine("  Device name: " + deviceName);

      var attempt = 1;
      var isFinished = false;

      var status = SystemCtlServiceStatus.NotSet;

      var serviceName = "growsense-mqtt-bridge-" + deviceName + ".service";

      while (!isFinished)
      {
        status = SystemCtl.Status(serviceName);

        if (attempt > 10 || status == SystemCtlServiceStatus.Active)
          isFinished = true;
        else
        {
          attempt++;
          
          Console.WriteLine("Failed attempt. Trying again...");
          Console.WriteLine("  Attempt: " + attempt);

          Thread.Sleep(1000);
        }
      }

      if (status != SystemCtlServiceStatus.Active)
      {
        throw new Exception("MQTT bridge service is not active for device: " + deviceName);
      }
      else
      {
        Console.WriteLine("  MQTT bridge service is active.");
        //var statusReport = SystemCtl.StatusReport(serviceName);

        // TODO: Remove if not needed. Disabled because it triggers from exceptions caused before connection succeeded.
        //if (statusReport.IndexOf("MqttConnectionException") > -1)
        //  throw new Exception("MQTT Bridge failed to connect to broker for device: " + deviceName);
        //if (statusReport.IndexOf("No such file or directory") > -1)
        //  throw new Exception("USB device not found for device: " + deviceName);
      }


      Console.WriteLine("Finished verifying MQTT bridge service is active.");
    }
  }
}
