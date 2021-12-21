using System;
namespace GrowSense.Core.Tools
{
  public class DockerHelper
  {
    public ProcessStarter Starter;
    public CLIContext Context;
    
    public DockerHelper(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
    }

    public virtual string Logs(string containerName)
    {
      Starter.OutputBuilder.Clear();
      Starter.StartBash("docker logs " + containerName);
      var output = Starter.Output;
      Starter.OutputBuilder.Clear();
      return output;
    }

    public virtual void Remove(string containerName, bool force)
    {
      Starter.StartBash("docker ps");
      var psOutput = Starter.Output;

      if (psOutput.IndexOf(containerName) > -1)
      {
        var cmd = "docker rm " + containerName;
        if (force)
          cmd += " -f";

        Starter.StartBash(cmd);
      }
    }

    public virtual string Execute(string runCmd)
    {
      if (!runCmd.StartsWith("docker"))
        runCmd = "docker " + runCmd;
        
      Starter.OutputBuilder.Clear();
      Starter.StartBash(runCmd);
      return Starter.Output;
    }

    public virtual string Processes()
    {
      return Execute("ps");
    }

    public virtual bool IsRunning(string containerName)
    {
      var logs = Logs(containerName);

      return logs.IndexOf("running") > -1;
        
    }
  }
}
