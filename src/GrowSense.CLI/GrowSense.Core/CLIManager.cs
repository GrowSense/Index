using System;
using GrowSense.Core.Verifiers;
using GrowSense.Core.Installers;
using System.IO;
namespace GrowSense.Core
{
  public class CLIManager
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public PostInstaller PostInstall;
    public Verifier Verifier;

    public CLIManager(CLIContext context)
    {
      Console.WriteLine("  Working directory: " + context.IndexDirectory);

      Context = context;
      Starter = new ProcessStarter();
      Starter.WorkingDirectory = Context.IndexDirectory;

      PostInstall = new Installers.PostInstaller(context);
      Verifier = new Verifier(context);
    }

    public void ExecuteScript(string script)
    {
      ExecuteBash("/usr/bin/bash " + script);
    }

    public void ExecuteBash(string command)
    {
      Console.WriteLine("Executing bash: " + command);

      Starter.Start(command);
    }

    public void PostInstallActions()
    {
      PostInstall.PrepareInstallation();
    }

    public void Verify()
    {
      Verifier.VerifyInstallation();
    }

    public void ApplySettings()
    {
      Console.WriteLine("Applying and saving new settings...");

      PostInstall.MqttBridge.SetAppConfigValues();
      PostInstall.UIController.SetAppConfigValues();

      PostInstall.ArduinoPlugAndPlay.SetAppConfigValues();

      if (Context.Settings.IsMockSystemCtl)
        File.WriteAllText(Context.IndexDirectory + "/is-mock-systemctl.txt", true.ToString());

      if (Context.Settings.IsMockDocker)
        File.WriteAllText(Context.IndexDirectory + "/is-mock-docker.txt", true.ToString());

      PostInstall.Verifier.VerifyInstallation();

      Console.WriteLine("Finished applying new settings.");
    }
  }
}
