using System;
using GrowSense.Core.Verifiers;
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
      Console.WriteLine("  Working directory: " + context.WorkingDirectory);
      
      Context = context;
      Starter = new ProcessStarter();
      Starter.WorkingDirectory = Context.WorkingDirectory;

      PostInstall = new PostInstaller(context);
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
      PostInstall.ExecutePostInstallActions();
    }

    public void Verify()
    {
      Verifier.VerifyInstallation();
    }
  }
}
