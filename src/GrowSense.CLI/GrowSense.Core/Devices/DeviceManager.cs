using System;
using System.IO;
using System.Collections.Generic;

namespace GrowSense.Core.Devices
{
  public class DeviceManager
  {
    public CLIContext Context;
  
    public DeviceManager(CLIContext context)
    {
      Context = context;
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
      device.IsDeviceOffline = Convert.ToBoolean(File.ReadAllText(deviceFolder + "/is-device-offline.txt").Trim());
      device.IsServiceOffline = Convert.ToBoolean(File.ReadAllText(deviceFolder + "/is-service-offline.txt").Trim());

      return device;
    }
  }
}
