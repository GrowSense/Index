using System;
using GrowSense.Core.Verifiers;
using System.IO;
using System.Linq;
using System.Threading;
using GrowSense.Core.Tools;

namespace GrowSense.Core.Installers
{
  public class WwwInstaller : BaseInstaller
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public WwwVerifier Verifier;
    public SystemCtlHelper SystemCtl;
    
    public WwwInstaller(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Verifier = new WwwVerifier(context);
      SystemCtl = new SystemCtlHelper(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing GrowSense Web GUI service...");

      Starter.StartBash("bash create-www-service.sh");
      
      Verify();
    }
    
    public void Restart()
    {
      SystemCtl.Restart("growsense-www");
    }

    public void Verify()
    {
      Verifier.Verify();
    }
  }
}

