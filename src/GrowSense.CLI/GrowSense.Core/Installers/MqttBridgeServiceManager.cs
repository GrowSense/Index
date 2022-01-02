using System;
using GrowSense.Core.Devices;
using System.IO;
using GrowSense.Core.Tools;
using GrowSense.Core.Verifiers;

namespace GrowSense.Core.Installers
{
  public class MqttBridgeServiceManager
  {
    public CLIContext Context;
    public SystemCtlHelper SystemCtl;
    public MqttBridgeServiceVerifier Verifier;
    
    public MqttBridgeServiceManager(CLIContext context)
    {
      Context = context;
      SystemCtl = new SystemCtlHelper(context);
      Verifier = new MqttBridgeServiceVerifier(context);
    }

    public void CreateService(DeviceInfo device)
    {
      Console.WriteLine("Creating MQTT bridge service...");
      Console.WriteLine("  Name: " + device.Name);
      Console.WriteLine("  Board: " + device.Board);
      Console.WriteLine("  Port: " + device.Port);

      if (IsOnLocal(device) && device.IsUSBConnected)
      {
        var servicesPath = Context.IndexDirectory + "/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc";
        var exampleServiceFile = "growsense-mqtt-bridge-" + device.Group + "1.service.example";
        
        var destinationServiceName = "growsense-mqtt-bridge-" + device.Name + ".service";
        var destinationServicePath = SystemCtl.GetServiceFilePath(destinationServiceName);

        if (File.Exists(destinationServicePath))
        {
          Console.WriteLine("Service already exists. Stopping and removing...");
        
          SystemCtl.Stop(destinationServiceName);
          File.Delete(destinationServicePath);
        }

        var fullExampleServicePath = servicesPath + "/" + exampleServiceFile;

        Console.WriteLine("  Example service file: " + fullExampleServicePath);

        if (!File.Exists(fullExampleServicePath))
          throw new FileNotFoundException("Can't find example service path: " + fullExampleServicePath);

        Console.WriteLine("  Destination service file: " + destinationServicePath);

        var serviceContent = File.ReadAllText(fullExampleServicePath);

        serviceContent = InsertValues(serviceContent, device);

        File.WriteAllText(destinationServicePath, serviceContent);

        SystemCtl.Reload();
        
        SystemCtl.Enable(destinationServiceName);
        SystemCtl.Start(destinationServiceName);

        Verifier.Verify(device.Name);
      }
      else
        Console.WriteLine("  Device is on a different host. Skipping creation...");

      Console.WriteLine("Finished creating MQTT bridge service.");
    }

    public void Restart(DeviceInfo[] devices)
    {
      Console.WriteLine("Restarting MQTT bridge services...");
      
      foreach (var device in devices)
      {
        Restart(device);
      }

      Console.WriteLine("Finished restarting MQTT bridge services.");
    }

    public void Restart(DeviceInfo device)
    {
      if (device.Host == Context.Settings.HostName)
      {
        if (device.Group != "ui")
        {
          var serviceName = "growsense-mqtt-bridge-" + device.Name;
          if (SystemCtl.Exists(serviceName))
          {
            SystemCtl.Restart(serviceName);
          }
        }
      }
     
    }

    public string InsertValues(string serviceContent, DeviceInfo device)
    {
      serviceContent = serviceContent.Replace(device.Group + "1", device.Name);
      serviceContent = serviceContent.Replace("/dev/ttyUSB0", device.Port);
      serviceContent = serviceContent.Replace("{IndexPath}", Context.IndexDirectory);

      return serviceContent;
    }

    public bool IsOnLocal(DeviceInfo device)
    {
      return device.Host == Context.Settings.HostName;
    }
  }
}
