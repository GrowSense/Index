using System;
namespace GrowSense.Core
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

    public string Logs(string containerName)
    {
      Starter.OutputBuilder.Clear();
      Starter.StartBash("docker logs " + containerName);
      var output = Starter.Output;
      Starter.OutputBuilder.Clear();
      return output;
    }

    public void Remove(string containerName, bool force)
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

    public void RunCommand(string runCmd)
    {
      Starter.StartBash(runCmd);
    }
  }
}
