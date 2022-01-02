using System;
using GrowSense.Core.Devices;
using System.IO;
namespace GrowSense.Core.Installers
{
  public class MqttBridgeStarter
  {
    public ProcessStarter Starter;
    public CLIContext Context;
    
    public MqttBridgeStarter(CLIContext context)
    {
      Starter = new ProcessStarter(context.IndexDirectory);
      Context = context;
    }

    public void StartMqttBridge(DeviceInfo device)
    {
      var subscribeTopics = GetSubscribeTopics(device);

      var port = device.Port;
      
      var arguments = "--DeviceName=" + device.Name + " --SerialPort=" + port + " --SubscribeTopics=" + subscribeTopics + " --SummaryKey=C";
      var exeFile = Context.IndexDirectory + "/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe";
      
      if (!File.Exists(exeFile))
        throw new FileNotFoundException("Can't find MQTT bridge exe file: " + exeFile);
      
      var cmd = "mono " + exeFile + " " + arguments;

      Starter.StartBash(cmd + " " + arguments);
    }

    public string GetSubscribeTopics(DeviceInfo device)
    {
      if (device.Group == "irrigator")
        return "D,W,T,M,I,B,O,F,Q";
      else if (device.Group == "illuminator")
        return "M,I,D,B,E,F,G,H,T,Q,C:";
      else if (device.Group == "ventilator")
        return "I,M,G,J,R,U,S,Q";
      else
        throw new NotImplementedException("Not implemented for device group: " + device.Group);
    }
  }
}
