using System;
using GrowSense.Core.Installers;
namespace GrowSense.Core.Devices
{
  public class DeviceServicesManager
  {
    public MqttBridgeServiceManager MqttBridge;
    public UIControllerServiceManager UIController;
    
    public DeviceServicesManager(CLIContext context)
    {
      MqttBridge = new MqttBridgeServiceManager(context);
      UIController = new UIControllerServiceManager(context);
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
        UIController.CreateService(device);
      else
        MqttBridge.CreateService(device);

      Console.WriteLine("Finished creating device services.");
    }
  }
}
