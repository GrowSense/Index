using System;
namespace GrowSense.Core.Installers
{
  public class DockerInstaller
  {
    public ProcessStarter Starter = new ProcessStarter();
    
    public DockerInstaller()
    {
    }

    public void InstallDocker()
    {
      Console.WriteLine("");
      Console.WriteLine("Installing docker...");
      
      Starter.Start("curl -fsSL get.docker.com -o get-docker.sh");
      Starter.Start("bash get-docker.sh");
      Console.Write(Starter.Output);

      //Starter.Start("usermod -aG docker $USER");
      //Starter.Start("dockerd-rootless-setuptool.sh install");
      Starter.OutputBuilder.Clear();

      Console.WriteLine("Finished installing docker");
      Console.WriteLine("");
    }
  }
}
