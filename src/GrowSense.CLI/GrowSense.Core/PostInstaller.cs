using System;
using System.IO;
using GrowSense.Core.Installers;
namespace GrowSense.Core
{
  public class PostInstaller
  {
    public CLIContext Context;
    public FileDownloader Downloader = new FileDownloader();
    public Installers.PostInstaller Prepare;
    
    public PostInstaller(CLIContext context)
    {
      Context = context;
      Prepare = new Installers.PostInstaller(context);
    }

    public void ExecutePostInstallActions()
    {
      Console.WriteLine("Executing post install actions...");
      
      Prepare.PrepareInstallation();
    }

  }
}
