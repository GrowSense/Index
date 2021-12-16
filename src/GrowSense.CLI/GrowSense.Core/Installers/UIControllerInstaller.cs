using System;
using GrowSense.Core.Verifiers;
using System.IO;
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
      Starter = new ProcessStarter(context.WorkingDirectory);
      Docker = new DockerHelper(context);
      Verifier = new UIControllerVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing system UI controller...");
      
      var uiControllerInstallPath = Path.GetFullPath(Context.WorkingDirectory + "/../../Serial1602ShieldSystemUIController");

      Console.WriteLine("  Install path: " + uiControllerInstallPath);

      EnsureDirectoriesExist(uiControllerInstallPath);

      CopyFilesToInstallDir(uiControllerInstallPath);


      Verify();
    }

    public void EnsureDirectoriesExist(string uiControllerInstallPath)
    {
      if (!Directory.Exists(uiControllerInstallPath))
        Directory.CreateDirectory(uiControllerInstallPath);        
    }

    public void CopyFilesToInstallDir(string uiControllerInstallPath)
    {
      Console.WriteLine("  Copying files to install dir...");
      
      var internalPath = Context.WorkingDirectory + "/scripts/apps/Serial1602ShieldSystemUIController";

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
