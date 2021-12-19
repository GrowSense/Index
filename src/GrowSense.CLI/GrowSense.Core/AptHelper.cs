using System;
namespace GrowSense.Core
{
  public class AptHelper
  {
    public ProcessStarter Starter = new ProcessStarter();

    public AptHelper()
    {
    }

    public void Update()
    {
      Console.WriteLine("Performing apt-get update...");
      Starter.Start("sudo apt-get update");

      if (Starter.Output.ToLower().IndexOf("permission denied") > -1)
        throw new Exception("Error: Permission denied. Do you need to run with sudo?");
        
      //Console.WriteLine(Starter.Output);
    }

    public void Install(params string[] packages)
    {
      InstallAll(String.Join(" ", packages));
      /*foreach (var package in packages)
      {
        Install(package);

      }*/
    }

    public bool IsInstalled(string package)
    {
      return false;
     // Starter.Start("which " + package);
     // return !String.IsNullOrEmpty(Starter.Output.Trim());
    }

    public void Install(string package)
    {
      if (!IsInstalled(package))
      {
      Console.WriteLine("Installing apt package: " + package);
        Starter.Start("sudo apt-get install -y " + package);
        //Console.WriteLine(Starter.Output);

        if (Starter.Output.IndexOf("Unable to locate package") > -1)
          throw new Exception("Unable to locate package: " + package);
        
        Starter.OutputBuilder.Clear();
        
        if (!IsInstalled(package))
          throw new Exception("Failed to install: " + package);
      }
      else
        Console.WriteLine("  Package '" + package + "' already installed.");
    }
    
    public void InstallAll(string packages)
    {
      Console.WriteLine("Performing apt-get install...");
      Console.WriteLine("  Packages: " + packages);
      
      Starter.Start("sudo apt-get install -y " + packages);
      //Console.WriteLine(Starter.Output);
      
      if (Starter.Output.ToLower().IndexOf("permission denied") > -1)
        throw new Exception("Error: Permission denied. Do you need to run with sudo?");
    }

    public bool IsPackageInstalled(string packageName)
    {
      var starter = new ProcessStarter();
      starter.ThrowExceptionOnError = false;
      starter.StartBash("dpkg -s " + packageName);

      if (starter.Output.IndexOf("is not installed") > -1)
        return false;
      else
        return true;
    }
  }
}
