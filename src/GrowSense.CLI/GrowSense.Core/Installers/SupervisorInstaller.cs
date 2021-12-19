using System;
using GrowSense.Core.Verifiers;
using System.IO;
using System.Linq;
using System.Threading;

namespace GrowSense.Core.Installers
{
  public class SupervisorInstaller : BaseInstaller
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public SupervisorVerifier Verifier;
    
    public SupervisorInstaller(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Verifier = new SupervisorVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing GrowSense supervisor...");

      Starter.StartBash("bash create-supervisor-service.sh");
      
      Verify();
    }

    public void Verify()
    {
      Verifier.Verify();
    }
  }
}

