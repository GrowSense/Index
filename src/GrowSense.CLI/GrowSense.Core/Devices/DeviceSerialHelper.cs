using System;
using System.IO.Ports;
using duinocom;
using System.Threading;
using System.Text;
namespace GrowSense.Core.Devices
{
  public class DeviceSerialHelper
  {

    public ProcessStarter Starter;
    public CLIContext Context;
    public DeviceInfoSerialExtractor Extractor;

    public DeviceSerialHelper(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Extractor = new DeviceInfoSerialExtractor();
    }

    public DeviceInfo ReadDeviceInfoFromSerial(string port)
    {
      Console.WriteLine("Reading device info from serial port...");
    
      var serialPort = new SerialPort(port, 9600);
      var client = new SerialClient(serialPort);

      if (!client.Port.IsOpen)
      {
        try
        {
          client.Open();
        }
        catch (Exception ex)
        {
          return null;
        }
        
        Console.WriteLine("Opened serial port");

        Thread.Sleep(2000);
      }

      var builder = new StringBuilder();

      Console.WriteLine("----- Start Output -----");

      while (client.Port.BytesToRead > 0 && builder.ToString().IndexOf(Extractor.EndDeviceInfoText) == -1)
      {
        var output = builder.ToString();
        var line = client.ReadLine().Trim();

        Console.WriteLine(line);
        
        builder.AppendLine(line);
      }

      Console.WriteLine("----- End Output -----");

      var deviceInfo = Extractor.ExtractInfo(port, builder.ToString());

      return deviceInfo;
    }

    public string Send(string port, string value)
    {
      var serialPort = new SerialPort(port, 9600);
      var client = new SerialClient(serialPort);

      client.Open();

      Thread.Sleep(2000);
      
      client.WriteLine(value);

      Thread.Sleep(1000);

      var response = client.Read();
      
      client.Close();

      return response;
    }
    
    
    public void SendDeviceNameCommand(DeviceInfo device)
    {
      var response = Send(device.Port, "Name:" + device.Name);

      if (response.IndexOf("Device name: " + device.Name) == -1)
        throw new Exception("Failed to set device name on target device.");
    }
      
  }
}
