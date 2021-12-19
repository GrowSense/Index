using System;
using System.IO;
using GrowSense.Core.Verifiers;
using System.Linq;
namespace GrowSense.Core.Installers
{
  public class ArduinoPlugAndPlayInstaller : BaseInstaller
  {
    public CLIContext Context;
    public FileDownloader Downloader = new FileDownloader();
    public ProcessStarter Starter;

    public ArduinoPlugAndPlayVerifier Verifier;
    
    public ArduinoPlugAndPlayInstaller(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Verifier = new ArduinoPlugAndPlayVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing ArduinoPlugAndPlay...");
      
      var installPath = GetInstallPath();
      
      Console.WriteLine("  Install dir: " + installPath);
      

      var cmd = String.Format("wget -nv --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/{0}/scripts-ols/install.sh | bash -s -- {0} {1} {2} {3} {4} {5} {6}",
      Context.Settings.Branch,
      installPath,
      Context.Settings.SmtpServer,
      Context.Settings.Email,
      Context.Settings.SmtpUsername,
      Context.Settings.SmtpPassword,
      Context.Settings.SmtpPort
    );

      Starter.StartBash(cmd);

      if (Starter.Output.ToLower().IndexOf("failed") > -1)
        throw new Exception("Arduino plug and play installation failed.");

      ImportArduinoPlugAndPlayConfig();

      SetAppConfigValues();

      Verifier.Verify();
    }
    
    public void SetAppConfigValues()
    {
      Console.WriteLine("Setting Arduino Plug and Play config values...");
      
    var installedConfigPath = Context.Paths.GetApplicationPath("ArduinoPlugAndPlay") + "/ArduinoPlugAndPlay/lib/net40/ArduinoPlugAndPlay.exe.config";

      var config = DeserializeAppConfig(installedConfigPath);

      config.AppSettings.Add.Where(e => e.Key == "SmtpServer").FirstOrDefault().Value = Context.Settings.SmtpServer;
      config.AppSettings.Add.Where(e => e.Key == "SmtpUsername").FirstOrDefault().Value = Context.Settings.SmtpUsername;
      config.AppSettings.Add.Where(e => e.Key == "SmtpPassword").FirstOrDefault().Value = Context.Settings.SmtpPassword;
      config.AppSettings.Add.Where(e => e.Key == "SmtpPort").FirstOrDefault().Value = Context.Settings.SmtpPort.ToString();
      config.AppSettings.Add.Where(e => e.Key == "EmailAddress").FirstOrDefault().Value = Context.Settings.Email;

      SerializeAppConfig(config, installedConfigPath);
    }

    public string GetInstallPath()
    {
      return Context.Paths.GetApplicationPath("ArduinoPlugAndPlay");
    }

    public void EnsureInstallDirectoryExists()
    {
      Console.WriteLine("    Ensuring install directory exists...");
      
      var installPath = GetInstallPath();

      if (!Directory.Exists(installPath))
      {
        Console.WriteLine("      Creating directory: " + installPath);
        Directory.CreateDirectory(installPath);
      }
      else
        Console.WriteLine("      Directory exists: " + installPath);
    }
    
    public void ImportArduinoPlugAndPlayConfig()
    {
      Console.WriteLine("  Importing arduino plug and play config...");

      var installPath = GetInstallPath();

      Console.WriteLine("    Install path: " + installPath);

      if (Context == null)
        throw new Exception("Context == null");

      if (Context.Settings == null)
        throw new Exception("Context.Settings == null");
      
      Console.WriteLine("    Branch: " + Context.Settings.Branch);
      
      var url = "https://raw.githubusercontent.com/GrowSense/Index/" + Context.Settings.Branch + "/scripts/apps/ArduinoPlugAndPlay/ArduinoPlugAndPlay.exe.config.system";
      var destination = Path.Combine(installPath, "ArduinoPlugAndPlay.exe.config");

      EnsureInstallDirectoryExists();

      Downloader.Download(url, destination);
    }
  }
}
