using System;
using System.IO;
using Newtonsoft.Json;

namespace GrowSense.Core
{
  class MainClass
  {
    public static void Main(string[] args)
    {
    //Environment.SetEnvironmentVariable("MONO_TLS_PROVIDER", "btls");
    
      Console.WriteLine("===== GrowSense CLI Console =====");
      
      var arguments = new Arguments(args);

      var workingDirectory = Path.GetFullPath("/"); 
      
      if (arguments.Contains("dir"))
        workingDirectory = Path.GetFullPath(arguments["dir"]);


      var settingsManager = new SettingsManager(workingDirectory);

      var settings = settingsManager.LoadSettings();

      try
      {

        var context = new CLIContext(workingDirectory, settings);

        var manager = CreateManager(context);
        
        settingsManager.ProcessSettingsFromArguments(arguments, settings);

        if (arguments.KeylessArguments.Length > 0)
        {
          var command = arguments.KeylessArguments[0];

          Console.WriteLine("  Command: " + command);

          switch (command)
          {
            case "hello-world":
              manager.ExecuteScript("hello-world.sh");
              break;
            case "post-install":
              Console.WriteLine("Post install");
              manager.PostInstallActions();
              break;
            case "verify":
              Console.WriteLine("Verify");
              manager.Verify();
              break;
            case "config":
              Console.WriteLine("Config");
              if (settingsManager.ProcessSettingsFromArguments(arguments, settings))
                manager.ApplySettings();
              break;
            default:
              Console.WriteLine("Unknown command: " + command);
              break;
          }
        }
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex.ToString());
        Environment.Exit(1);
      }      
    }

    static public CLIManager CreateManager(CLIContext context)
    {
      var manager = new CLIManager(context);

      if (context.Settings.IsMockSystemCtl)
      {
        var mockSystemCtl = new MockSystemCtlHelper(context);
        manager.PostInstall.Docker.Verifier.SystemCtl = mockSystemCtl;
        manager.PostInstall.Supervisor.Verifier.SystemCtl = mockSystemCtl;
        manager.PostInstall.WWW.Verifier.SystemCtl = mockSystemCtl;
      }

      return manager;
    }
  }
}
