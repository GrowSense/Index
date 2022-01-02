using System;
namespace GrowSense.Core
{
  public class DeviceManager
  {
    public ProcessStarter Starter;
    public CLIContext Context;
    
    public DeviceManager(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
    }

  }
}
