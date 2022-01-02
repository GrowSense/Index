using System;
using System.IO;
namespace GrowSense.Core
{
  public class PathHelper
  {
    public CLIContext Context;
    
    public PathHelper(CLIContext context)
    {
      Context = context;
    }

    public void Initialize(string startingDirectory)
    {
      Console.WriteLine("Initializing paths...");
      Console.WriteLine("  Starting directory: " + startingDirectory);
      
      var strippedDirectory = RemoveSubDirs(startingDirectory);

      Context.ParentDirectory = strippedDirectory;

      Console.WriteLine("  Parent directory: " + Context.ParentDirectory);

      Console.WriteLine("  Index directory: " + Context.IndexDirectory);
    }

    public string RemoveSubDirs(string startingDirectory)
    {
      var strippedDir = startingDirectory.TrimEnd('/');

      if (strippedDir.Trim('/').EndsWith("Index"))
        strippedDir = Path.GetDirectoryName(strippedDir);
        
      if (strippedDir.Trim('/').EndsWith("GrowSense"))
        strippedDir = Path.GetDirectoryName(strippedDir);

      return strippedDir;
    }

    public string GetApplicationPath(string applicationName)
    {
      if (applicationName == "mosquitto")
        return Path.Combine(Context.IndexDirectory + "/scripts/docker/mosquitto");
      else if (applicationName == "BridgeArduinoSerialToMqttSplitCsv")
        return Path.Combine(Context.IndexDirectory + "/scripts/apps/BridgeArduinoSerialToMqttSplitCsv");
      else if (applicationName == "Serial1602ShieldSystemUIController")
        return Path.Combine(Context.IndexDirectory + "/scripts/apps/Serial1602ShieldSystemUIController");
      else
        return Path.Combine(Context.ParentDirectory, applicationName.Trim('/'));
    }
  }
}
