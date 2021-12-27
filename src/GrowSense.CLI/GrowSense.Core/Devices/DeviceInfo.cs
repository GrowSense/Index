using System;
namespace GrowSense.Core.Devices
{
  public class DeviceInfo
  {
    public string Name;
    public string Label;
    public string Board;
    public string Project;
    public string Group;
    public string Family;
    public string Port;
    public string Host;
    public bool IsUSBConnected;
    public bool IsDeviceOffline;
    public bool IsServiceOffline;
    
    public DeviceInfo()
    {
    }
  }
}
