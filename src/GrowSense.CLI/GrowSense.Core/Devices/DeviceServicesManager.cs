using System;
using GrowSense.Core.Installers;
namespace GrowSense.Core.Devices
{
  public class DeviceServicesManager
  {
    public MqttBridgeServiceManager MqttBridge;
    
    public DeviceServicesManager(CLIContext context)
    {
      MqttBridge = new MqttBridgeServiceManager(context);
    }

    public void CreateDeviceServices(DeviceInfo device)
    {
      Console.WriteLine("Creating device services...");
      Console.WriteLine("  Name: " + device.Name);
      Console.WriteLine("  Board: " + device.Board);
      Console.WriteLine("  Port: " + device.Port);

      if (device.Board == "esp")
        Console.WriteLine("  ESP device. No services need to be created.");
      else if (device.Group == "ui")
        throw new NotImplementedException("UI device not yet implemented.");
      else
        MqttBridge.CreateService(device);

      Console.WriteLine("Finished creating device services.");
    }
  }
}
