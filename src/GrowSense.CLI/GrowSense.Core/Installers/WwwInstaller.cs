using System;
using GrowSense.Core.Verifiers;
using System.IO;
using System.Linq;
using System.Threading;

namespace GrowSense.Core.Installers
{
  public class WwwInstaller : BaseInstaller
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public WwwVerifier Verifier;
    
    public WwwInstaller(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Verifier = new WwwVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing GrowSense Web GUI service...");

      Starter.StartBash("bash create-www-service.sh");
      
      Verify();
    }

    public void Verify()
    {
      Verifier.Verify();
    }
  }
}

