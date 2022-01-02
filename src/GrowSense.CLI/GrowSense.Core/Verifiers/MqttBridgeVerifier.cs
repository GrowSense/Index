using System;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Linq;
using System.Xml.Serialization;
using GrowSense.Core.Model;
using GrowSense.Core.Devices;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Verifiers
{
  public class MqttBridgeVerifier : BaseVerifier
  {
    public DeviceManager Devices;
    
    public MqttBridgeVerifier(CLIContext context) : base(context)
    {
      Devices = new DeviceManager(context);
    }

    public void Verify()
    {
      Console.WriteLine("Verifying MQTT bridge app is installed...");

      var mqttBridgeName = "BridgeArduinoSerialToMqttSplitCsv";
      var installDir = Context.Paths.GetApplicationPath(mqttBridgeName);

      AssertDirectoryExists(installDir);

      VerifyVersion(installDir);

      VerifyConfig(installDir);

      VerifyBinary(installDir);

      VerifyDevicesMqttBridgeServices();
    }

    public void VerifyDevicesMqttBridgeServices()
    {
      Console.WriteLine("  Verifying devices MQTT bridge services...");

      foreach (var device in Devices.GetDevices())
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
          VerifyDeviceMqttBridgeService(device);
      }

      Console.WriteLine("  Finished verifying devices MQTT bridge services.");
    }

    public void VerifyDeviceMqttBridgeService(DeviceInfo device)
    {
      var serviceName = "growsense-mqtt-bridge-" + device.Name;

      var mqttBridgeStatus = SystemCtl.Status(serviceName);

      if (mqttBridgeStatus != SystemCtlServiceStatus.Active)
      {
        throw new Exception("MQTT bridge service is not active for device: " + device.Name);
      }
      else
      {
        var statusReport = SystemCtl.StatusReport(serviceName);

        if (statusReport.IndexOf("MqttConnectionException") > -1)
          throw new Exception("MQTT Bridge failed to connect to broker for device: " + device.Name);
        else if (statusReport.IndexOf("No such file or directory") > -1)
          throw new Exception("USB device not found for device: " + device.Name);
      }
    }

    public void VerifyBinary(string installDir)
    {
      var installedExePath = installDir + "/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe";

      AssertFileExists(installedExePath);
    }

    public void VerifyVersion(string installDir)
    {
      var internalVersion = File.ReadAllText(Context.IndexDirectory + "/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/version.txt").Trim();
      var installedVersionPath = installDir + "/BridgeArduinoSerialToMqttSplitCsv/lib/net40/version.txt";

      AssertFileExists(installedVersionPath);

      var installedVersion = File.ReadAllText(installedVersionPath).Trim();

      if (internalVersion != installedVersion)
      {
        Console.WriteLine("    Internal version: " + internalVersion);
        Console.WriteLine("    Installed version: " + installedVersion);

        throw new Exception("Installed MQTT bridge version doesn't match internal version.");
      }
    }

    public void VerifyConfig(string installDir)
    {
      Console.WriteLine("  Verifying MQTT bridge config file...");
      var installedConfigPath = installDir + "/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";

      Console.WriteLine("    " + installedConfigPath);

      AssertFileExists(installedConfigPath);

      var config = DeserializeAppConfig(installedConfigPath);

      VerifyAppConfig(config);
    }

    public void VerifyAppConfig(AppConfig config)
    {
      AssertAppConfig(config, "UserId", Context.Settings.MqttUsername);
      AssertAppConfig(config, "Password", Context.Settings.MqttPassword);
      AssertAppConfig(config, "MqttPort", Context.Settings.MqttPort.ToString());
      AssertAppConfig(config, "Host", Context.Settings.MqttHost);

      AssertAppConfig(config, "SmtpServer", Context.Settings.SmtpServer);
      AssertAppConfig(config, "SmtpUsername", Context.Settings.SmtpUsername);
      AssertAppConfig(config, "SmtpPassword", Context.Settings.SmtpPassword);
      AssertAppConfig(config, "SmtpPort", Context.Settings.SmtpPort.ToString());
      AssertAppConfig(config, "EmailAddress", Context.Settings.Email);
    }
  }
}