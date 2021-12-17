using System;
using GrowSense.Core.Verifiers;
using System.Threading;
namespace GrowSense.Core.Installers
{
  public class DockerInstaller
  {
    public ProcessStarter Starter = new ProcessStarter();

    public DockerVerifier Verifier;

    public CLIContext Context;
    
    public DockerInstaller(CLIContext context)
    {
      Context = context;

      Verifier = new DockerVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("");
      Console.WriteLine("Installing docker...");

      if (!IsDockerInstalled())
      {

        Starter.StartBash("curl -fsSL get.docker.com -o get-docker.sh");
        Starter.StartBash("bash get-docker.sh");
        //Console.Write(Starter.Output);

        //Starter.Start("usermod -aG docker $USER");
        //Starter.Start("dockerd-rootless-setuptool.sh install");
       // Starter.OutputBuilder.Clear();

        Console.WriteLine("Finished installing docker");
        Console.WriteLine("");
      }
      else
        Console.WriteLine("Docker is already installed");

//      Console.WriteLine("  Ensuring docker is started...");
//        Starter.StartBash("service docker start");
//        Starter.StartBash("systemctl start docker.service");

      //Thread.Sleep(5000);

      Verifier.Verify();
    }

    public bool IsDockerInstalled()
    {
      Console.WriteLine("  Checking whether docker is installed...");
      
      Starter.StartBash("whereis docker");

      if (Starter.Output.IndexOf("not found") > -1)
      {
        Console.WriteLine("    Docker is not installed.");
        return false;
      }
      else
      {
        Console.WriteLine("    Docker is installed.");
        return true;
      }
    }
    
  }
}
