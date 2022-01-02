using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

namespace GrowSense.Core.Devices
{
  public class DeviceManager
  {
    public CLIContext Context;
    public DeviceSerialHelper Serial;
    public DeviceServicesManager Services;
  
    public DeviceManager(CLIContext context)
    {
      Context = context;
      Serial = new DeviceSerialHelper(context);
      Services = new DeviceServicesManager(context);
    }

    public DeviceInfo[] GetDevices()
    {
      var devices = new List<DeviceInfo>();

      var devicesDir = Path.Combine(Context.IndexDirectory, "devices");

      if (Directory.Exists(devicesDir))
      {
        foreach (var deviceFolder in Directory.GetDirectories(devicesDir))
        {
          var deviceName = Path.GetFileName(deviceFolder);

          devices.Add(GetDevice(deviceName));
        }
      }

      return devices.ToArray();
    }

    public DeviceInfo GetDevice(string deviceName)
    {
      var deviceFolder = Context.IndexDirectory + "/devices/" + deviceName;

      var device = new DeviceInfo();

      device.Name = deviceName;
      device.Label = File.ReadAllText(deviceFolder + "/label.txt").Trim();
      device.Board = File.ReadAllText(deviceFolder + "/board.txt").Trim();
      device.Project = File.ReadAllText(deviceFolder + "/project.txt").Trim();
      device.Group = File.ReadAllText(deviceFolder + "/group.txt").Trim();
      device.Family = File.ReadAllText(deviceFolder + "/family.txt").Trim();
      device.Port = File.ReadAllText(deviceFolder + "/port.txt").Trim();
      device.Host = File.ReadAllText(deviceFolder + "/host.txt").Trim();
      if (File.Exists(deviceFolder + "/is-device-offline.txt"))
        Boolean.TryParse(File.ReadAllText(deviceFolder + "/is-device-offline.txt").Trim(), out device.IsDeviceOffline);
      if (File.Exists(deviceFolder + "/is-service-offline.txt"))
        Boolean.TryParse(File.ReadAllText(deviceFolder + "/is-service-offline.txt").Trim(), out device.IsServiceOffline);

      return device;
    }
    
    public void AddDevice(string port)
    {
      Console.WriteLine("Adding device...");
      Console.WriteLine("  Port: " + port);
      
      var device = Serial.ReadDeviceInfoFromSerial(port);

      if (device == null)
        Console.WriteLine("  No device found. Make sure it's connected and that you have the correct port.");
      else if (String.IsNullOrEmpty(device.Group))
        Console.WriteLine("  Failed to read device info. Is an existing service already connected to it?");
      else
      {
        if (String.IsNullOrEmpty(device.Name) || device.Name.ToLower().StartsWith("new"))
        {
          GenerateDeviceName(device);
        }
        
        if (String.IsNullOrEmpty(device.Label))
          GenerateDeviceLabel(device);

        device.Host = Context.Settings.HostName;

        Serial.SendDeviceNameCommand(device);

        CreateDeviceInfo(device);

        Services.CreateDeviceServices(device);

        Console.WriteLine("Finished adding device.");
      }
    }

    public void GenerateDeviceName(DeviceInfo device)
    {
      var finished = false;

      var name = "";

      var i = 1;
      
      while (!finished)
      {
        name = device.Group + i;

        if (!IsInUse(name))
          finished = true;
        else
          i++;
      }

      device.Name = name;
    }

    public void GenerateDeviceLabel(DeviceInfo device)
    {

      if (String.IsNullOrEmpty(device.Name))
        throw new ArgumentException("device.Name is empty");

      var label = device.Name.First().ToString().ToUpper() + String.Join("", device.Name.Skip(1));

      device.Label = label;
    }

    public bool IsInUse(string name)
    {
      return Directory.Exists(GetDevicesDirectory() + "/" + name);
    }

    public void CreateDeviceInfo(DeviceInfo device)
    {
      Console.WriteLine("Creating device info...");
      
      var devicesDirectory = GetDevicesDirectory();

      var deviceDirectory = devicesDirectory + "/" + device.Name;

      Console.WriteLine("  Device: " + device.Name);
      Console.WriteLine("  Device directory: " + deviceDirectory);

      if (!Directory.Exists(deviceDirectory))
        Directory.CreateDirectory(deviceDirectory);

      File.WriteAllText(deviceDirectory + "/board.txt", device.Board);
      File.WriteAllText(deviceDirectory + "/project.txt", device.Project);
      File.WriteAllText(deviceDirectory + "/label.txt", device.Label);
      File.WriteAllText(deviceDirectory + "/name.txt", device.Name);
      File.WriteAllText(deviceDirectory + "/port.txt", device.Port);
      File.WriteAllText(deviceDirectory + "/group.txt", device.Group);
      File.WriteAllText(deviceDirectory + "/family.txt", device.Family);
      File.WriteAllText(deviceDirectory + "/host.txt", device.Host);
      File.WriteAllText(deviceDirectory + "/is-usb-connected.txt", device.IsUSBConnected.ToString());

      Console.WriteLine("Finished creating device info.");
      
      //echo "1" > $DEVICE_DIR/is-usb-connected.txt || exit 1
    }

    public string GetDevicesDirectory()
    {
      return Context.IndexDirectory + "/devices";
    }
  }
}
