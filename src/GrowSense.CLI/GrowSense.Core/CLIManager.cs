using System;
using GrowSense.Core.Verifiers;
using GrowSense.Core.Installers;
namespace GrowSense.Core
{
  public class CLIManager
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public Installers.PostInstaller PostInstall;
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
  }
}
