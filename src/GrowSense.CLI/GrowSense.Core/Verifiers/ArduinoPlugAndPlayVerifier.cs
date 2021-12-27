using System;
using System.IO;
using GrowSense.Core.Model;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Verifiers
{
  public class ArduinoPlugAndPlayVerifier : BaseVerifier
  {
    public SystemCtlHelper SystemCtl;
    
    public ArduinoPlugAndPlayVerifier(CLIContext context) : base(context)
    {
      SystemCtl = new SystemCtlHelper(context);
    }

    public void Verify()
    {
      var arduinoPlugAndPlayName = "ArduinoPlugAndPlay";
      var installDir = Path.GetFullPath(Context.IndexDirectory + "/../../" + arduinoPlugAndPlayName);

      VerifyIsInstalled();

      VerifyAppConfig(installDir);

      VerifyServiceIsRunning();
    }

    public void VerifyIsInstalled()
    {
      var installPath = GetInstallPath();

      AssertDirectoryExists(installPath);
      
      var installedExePath = installPath + "/ArduinoPlugAndPlay/lib/net40/ArduinoPlugAndPlay.exe";

      AssertFileExists(installedExePath);
    }
    
    public void VerifyAppConfig(string installDir)
    {
      var installedConfigPath = installDir + "/ArduinoPlugAndPlay/lib/net40/ArduinoPlugAndPlay.exe.config";

      var config = DeserializeAppConfig(installedConfigPath);

      VerifyAppConfig(config);
    }

    public void VerifyAppConfig(AppConfig config)
    {
      AssertAppConfig(config, "SmtpServer", Context.Settings.SmtpServer);
      AssertAppConfig(config, "SmtpUsername", Context.Settings.SmtpUsername);
      AssertAppConfig(config, "SmtpPassword", Context.Settings.SmtpPassword);
      AssertAppConfig(config, "SmtpPort", Context.Settings.SmtpPort.ToString());
      AssertAppConfig(config, "EmailAddress", Context.Settings.Email);
    }

    public void VerifyServiceIsRunning()
    {
      Console.WriteLine("Verifying Arduino Plug and Play service is running...");

      //var mockSystemctlFile = GetInstallPath() + "/is-mock-systemctl.txt";

      //if (!File.Exists(mockSystemctlFile))
      //{
      //var cmd = 

      //Starter.StartBash(cmd);

      var output = SystemCtl.StatusReport("arduino-plug-and-play");

      AssertTextContains(output, "active (running)", "Arduino plug and play service is not running.");
      //}
    }

    public string GetInstallPath()
    {
      return Path.Combine(Context.IndexDirectory, "../../ArduinoPlugAndPlay");
    }
  }
}
