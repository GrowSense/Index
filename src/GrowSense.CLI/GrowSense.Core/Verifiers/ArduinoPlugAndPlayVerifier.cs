﻿using System;
using System.IO;
using GrowSense.Core.Model;
namespace GrowSense.Core.Verifiers
{
  public class ArduinoPlugAndPlayVerifier : BaseVerifier
  {
    public ArduinoPlugAndPlayVerifier(CLIContext context) : base(context)
    {
    }

    public void Verify()
    {
      var arduinoPlugAndPlayName = "ArduinoPlugAndPlay";
      var installDir = Path.GetFullPath(Context.WorkingDirectory + "/../../" + arduinoPlugAndPlayName);

      VerifyIsInstalled();

      VerifyAppConfig(installDir);

      VerifyServiceIsRunning();
    }

    public void VerifyIsInstalled()
    {
      var installPath = GetInstallPath();

      AssertDirectoryExists(installPath);
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
    var mockSystemctlFile = GetInstallPath() + "/is-mock-systemctl.txt";

      if (!File.Exists(mockSystemctlFile))
      {
        var cmd = "systemctl status arduino-plug-and-play.service";

        Starter.StartBash(cmd);

        var output = Starter.Output;

        AssertTextContains(output, "active (running)", "Arduino plug and play service is not running.");
      }
    }

    public string GetInstallPath()
    {
      return Path.Combine(Context.WorkingDirectory, "../../ArduinoPlugAndPlay");
    }
  }
}