using System;
using System.IO;
namespace GrowSense.Core
{
  public class PostInstaller
  {
    public CLIContext Context;
    public FileDownloader Downloader = new FileDownloader();
    public Preparer Prepare;
    
    public PostInstaller(CLIContext context)
    {
      Context = context;
      Prepare = new Preparer(context);
    }

    public void ExecutePostInstallActions()
    {
      Console.WriteLine("Executing post install actions...");
      
      Prepare.PrepareInstallation();
    }

  }
}
