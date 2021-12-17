using System;
using System.IO;
using GrowSense.Core.Model;
namespace GrowSense.Core.Verifiers
{
  public class UIControllerVerifier : BaseVerifier
  {
    public UIControllerVerifier(CLIContext context) : base(context)
    {
    }
    
    
    public void Verify()
    {
      Console.WriteLine("Verifying UI controller is installed...");
      
      var appName = "Serial1602ShieldSystemUIController";
      var installDir = Path.GetFullPath(Context.IndexDirectory + "/../../" + appName);

      AssertDirectoryExists(installDir);

      VerifyVersion(installDir);

      VerifyConfig(installDir);
    }

    public void VerifyVersion(string installDir)
    {
    var internalVersion = File.ReadAllText(Context.IndexDirectory + "/scripts/apps/Serial1602ShieldSystemUIController/version.txt").Trim();
      var installedVersionPath = installDir + "/Serial1602ShieldSystemUIController/lib/net40/version.txt";

      AssertFileExists(installedVersionPath);

      var installedVersion = File.ReadAllText(installedVersionPath).Trim();

      if (internalVersion != installedVersion)
      {
        Console.WriteLine("    Internal version: " + internalVersion);
        Console.WriteLine("    Installed version: " + installedVersion);

        throw new Exception("Installed system UI controller doesn't match internal version.");
      }
    }
    
    public void VerifyConfig(string installDir)
    {
    var installedConfigPath = installDir + "/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIControllerConsole.exe.config";

      var config = DeserializeAppConfig(installedConfigPath);

      VerifyAppConfig(config);
      //var xml = XElement.Load(installedConfigPath);

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
