using System;
using System.IO;
using Newtonsoft.Json;

namespace GrowSense.Core
{
  class MainClass
  {
    public static void Main(string[] args)
    {
      Console.WriteLine("===== GrowSense CLI Console =====");
     
      
      var arguments = new Arguments(args);

      var workingDirectory = Path.GetFullPath("/"); 
      
      if (arguments.Contains("dir"))
        workingDirectory = Path.GetFullPath(arguments["dir"]);


      var settingsManager = new SettingsManager(workingDirectory);

      var settings = settingsManager.LoadSettings();

      settingsManager.ProcessSettingsFromArguments(arguments, settings);
      
      var context = new CLIContext(workingDirectory, settings);

      var manager = new CLIManager(context);
      
      if (arguments.KeylessArguments.Length > 0)
      {
        var command = arguments.KeylessArguments[0];

        Console.WriteLine("  Command: " + command);

        switch (command)
        {
          case "hello-world":
            manager.ExecuteScript("hello-world.sh");
            break;
          case "prepare":
            manager.ExecuteScript("prepare.sh");
            break;
          case "post-install":
            Console.WriteLine("Post install");
            manager.PostInstallActions();
            break;
          case "verify":
            Console.WriteLine("Verify");
            manager.Verify();
            break;
          default:
            Console.WriteLine("Unknown command: " + command);
            break;
        }
      }
      
    }
  }
}
