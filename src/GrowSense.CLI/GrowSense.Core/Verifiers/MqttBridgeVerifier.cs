using System;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Linq;
using System.Xml.Serialization;
using GrowSense.Core.Model;
namespace GrowSense.Core.Verifiers
{
  public class MqttBridgeVerifier : BaseVerifier
  {
    public MqttBridgeVerifier(CLIContext context) : base(context)
    {
    }
    
    
    public void Verify()
    {
      Console.WriteLine("Verifying MQTT bridge app is installed...");
      
      var mqttBridgeName = "BridgeArduinoSerialToMqttSplitCsv";
      var installDir = Path.GetFullPath(Context.WorkingDirectory + "/../../" + mqttBridgeName);

      AssertDirectoryExists(installDir);

      VerifyVersion(installDir);

      VerifyConfig(installDir);
    }

    public void VerifyVersion(string installDir)
    {
    var internalVersion = File.ReadAllText(Context.WorkingDirectory + "/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/version.txt").Trim();
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
      var installedConfigPath = installDir + "/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";

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
