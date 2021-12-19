using System;
namespace GrowSense.Core
{
  public class SystemCtlHelper
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    
    public SystemCtlHelper(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(Context.IndexDirectory);
    }

    public string Status(string serviceName)
    {
      return Run("status " + serviceName);
    }

    public string Run(string command)
    {
      if (Context.Settings.IsMockSystemCtl)
      {
      var output = "[mock] systemctl " + command;
        Console.WriteLine(output);
        return output;
      }
      else
      {
        Starter.StartBash("systemctl " + command);
        return Starter.Output;
      }
    }
  }
}
