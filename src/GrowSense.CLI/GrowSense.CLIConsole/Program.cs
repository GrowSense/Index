using System;
using System.IO;
using Newtonsoft.Json;
using GrowSense.Core.Tools.Mock;

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


      //var settingsManager = new SettingsManager(workingDirectory);

      var settings = GetSettings(workingDirectory, arguments);

        var context = new CLIContext(workingDirectory, settings);

        var manager = CreateManager(context);
        
      try
      {
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
        manager.PostInstall.Verifier.SystemCtl = mockSystemCtl;
        manager.PostInstall.Verifier.Docker.SystemCtl = mockSystemCtl;
        manager.PostInstall.Verifier.Supervisor.SystemCtl = mockSystemCtl;
        manager.PostInstall.Verifier.WWW.SystemCtl = mockSystemCtl;
      }

      if (context.Settings.IsMockDocker)
      {
        var mockDocker = new MockDockerHelper(context);
        manager.PostInstall.Mqtt.Docker = mockDocker;
      }

      return manager;
    }

    static public CLISettings GetSettings(string workingDirectory, Arguments arguments)
    {
      var settingsManager = new SettingsManager(workingDirectory);

      var settings = settingsManager.LoadSettings();
      
      settingsManager.LoadSettingsFromArguments(arguments, settings);

      return settings;
    }
  }
}
