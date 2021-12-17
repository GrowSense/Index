using System;
using System.Threading;
namespace GrowSense.Core.Verifiers
{
  public class DockerVerifier : BaseVerifier
  {
    public DockerVerifier(CLIContext context) : base(context)
    {
    }
    
    
    public void Verify()
    {
      Console.WriteLine("Verifying docker is running...");

      VerifyDockerPSCommand();
  
      //VerifySystemCtlStatus();
    }

    public void VerifySystemCtlStatus()
    {
    
      Console.WriteLine("  Checking output of 'systemctl status docker'...");

      var starter = new ProcessStarter(Context.IndexDirectory);
      starter.StartBash("systemctl status docker");
      var output = starter.Output;

      if (output.IndexOf("active (running)") == -1)
      {
        Console.WriteLine("----- Start Output -----");
        Console.WriteLine(output);
        Console.WriteLine("----- End Output -----");
        
      var starter2 = new ProcessStarter(Context.IndexDirectory);
      starter.StartBash("dockerd");
      var output2 = starter.Output;
        
        throw new Exception("Docker service is not running. Didn't find 'active' in systemctl status docker output");
      }

      if (output.IndexOf("System has not been booted with systemd") > -1)
        throw new Exception("Systemd/systemctl is not available in docker container.");
        
      if (output.IndexOf("Can't operate") > -1)
        throw new Exception("Error using docker");
    }

    public void VerifyDockerPSCommand()
    {
      Console.WriteLine("  Checking output of 'docker ps'...");

      var starter = new ProcessStarter(Context.IndexDirectory);
      starter.StartBash("docker ps");
      var output = starter.Output;

      if (output.IndexOf("CONTAINER ID") == -1)
      {
        Console.WriteLine("----- Start Output -----");
        Console.WriteLine(output);
        Console.WriteLine("----- End Output -----");
        
        throw new Exception("Docker service is not running.");// Didn't find 'active' in systemctl status docker output");
      }

      //if (output.IndexOf("System has not been booted with systemd") > -1)
      //  throw new Exception("Systemd/systemctl is not available in docker container.");
        
      //if (output.IndexOf("Can't operate") > -1)
      //  throw new Exception("Error using docker");

    }

  }
}
