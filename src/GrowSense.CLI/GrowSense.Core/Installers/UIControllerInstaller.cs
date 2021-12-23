using System;
using GrowSense.Core.Verifiers;
using System.IO;
using System.Linq;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Installers
{
  public class UIControllerInstaller : BaseInstaller
  {
public CLIContext Context;
    public ProcessStarter Starter;
    public DockerHelper Docker;
    public UIControllerVerifier Verifier;
    
    public UIControllerInstaller(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Docker = new DockerHelper(context);
      Verifier = new UIControllerVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing system UI controller...");
      
      var uiControllerInstallPath = Context.Paths.GetApplicationPath("Serial1602ShieldSystemUIController");

      Console.WriteLine("  Install path: " + uiControllerInstallPath);

      EnsureDirectoriesExist(uiControllerInstallPath);

      CopyFilesToInstallDir(uiControllerInstallPath);

      SetAppConfigValues();

      Verify();
    }


    public void SetAppConfigValues()
    {
    var installedConfigPath = Context.Paths.GetApplicationPath("Serial1602ShieldSystemUIController") + "/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIControllerConsole.exe.config";

      var config = DeserializeAppConfig(installedConfigPath);

      config.AppSettings.Add.Where(e => e.Key == "Host").FirstOrDefault().Value = Context.Settings.MqttHost;
      config.AppSettings.Add.Where(e => e.Key == "UserId").FirstOrDefault().Value = Context.Settings.MqttUsername;
      config.AppSettings.Add.Where(e => e.Key == "Password").FirstOrDefault().Value = Context.Settings.MqttPassword;
      config.AppSettings.Add.Where(e => e.Key == "MqttPort").FirstOrDefault().Value = Context.Settings.MqttPort.ToString();

      config.AppSettings.Add.Where(e => e.Key == "SmtpServer").FirstOrDefault().Value = Context.Settings.SmtpServer;
      config.AppSettings.Add.Where(e => e.Key == "SmtpUsername").FirstOrDefault().Value = Context.Settings.SmtpUsername;
      config.AppSettings.Add.Where(e => e.Key == "SmtpPassword").FirstOrDefault().Value = Context.Settings.SmtpPassword;
      config.AppSettings.Add.Where(e => e.Key == "SmtpPort").FirstOrDefault().Value = Context.Settings.SmtpPort.ToString();
      config.AppSettings.Add.Where(e => e.Key == "EmailAddress").FirstOrDefault().Value = Context.Settings.Email;

      SerializeAppConfig(config, installedConfigPath);
    }

    public void EnsureDirectoriesExist(string uiControllerInstallPath)
    {
      if (!Directory.Exists(uiControllerInstallPath))
        Directory.CreateDirectory(uiControllerInstallPath);        
    }

    public void CopyFilesToInstallDir(string uiControllerInstallPath)
    {
      Console.WriteLine("  Copying files to install dir...");
      
      var internalPath = Context.IndexDirectory + "/scripts/apps/Serial1602ShieldSystemUIController";

      Console.WriteLine("    Internal path: " + internalPath);
      Console.WriteLine("    Install path: " + uiControllerInstallPath);

      var dirsToCopy = new string[] { "Serial1602ShieldSystemUIController" };

      var filesToCopy = new string[] { "Serial1602ShieldSystemUIController*.zip",
      "init.sh",
      "install-package-from-github-release.sh",
      "Serial1602ShieldSystemUIControllerConsole.exe.config.system",
      "start-ui-controller.sh"
      };

      CopyDirectories(internalPath, uiControllerInstallPath, dirsToCopy);

      CopyFiles(internalPath, uiControllerInstallPath, filesToCopy);
      
    }

    public void Verify()
    {
      Verifier.Verify();
    }
  }
}
