using System;
using System.IO;
using GrowSense.Core.Verifiers;
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
      Starter = new ProcessStarter(context.WorkingDirectory);
      Verifier = new ArduinoPlugAndPlayVerifier(context);
    }

    public void Install()
    {
      var installPath = GetInstallPath();

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

      Verifier.Verify();
    }

    public string GetInstallPath()
    {
      return Path.GetFullPath(Context.WorkingDirectory + "/../../ArduinoPlugAndPlay");
    }

    public void EnsureInstallDirectoryExists()
    {
      var installPath = Path.GetFullPath(Context.WorkingDirectory + "/../../ArduinoPlugAndPlay");

      if (!Directory.Exists(installPath))
        Directory.CreateDirectory(installPath);
    }
    
    public void ImportArduinoPlugAndPlayConfig()
    {
      Console.WriteLine("  Importing arduino plug and play config...");

      if (Context == null)
        throw new Exception("Context == null");

      if (Context.Settings == null)
        throw new Exception("Context.Settings == null");
      
      Console.WriteLine("    Branch: " + Context.Settings.Branch);
      
      var url = "https://raw.githubusercontent.com/GrowSense/Index/" + Context.Settings.Branch + "/scripts/apps/ArduinoPlugAndPlay/ArduinoPlugAndPlay.exe.config.system";
    var destinationFolder = Path.GetFullPath(Context.WorkingDirectory + "/../ArduinoPlugAndPlay.exe.config");

      Downloader.Download(url, destinationFolder);
    }
  }
}
