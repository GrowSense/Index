using System;
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

      var starter = new ProcessStarter(Context.WorkingDirectory);
      starter.StartBash("systemctl status docker");
      var output = Starter.Output;
      
      if (output.IndexOf("Active (running)") == -1)
        throw new Exception("Docker service is not running");

      if (output.IndexOf("System has not been booted with systemd") > -1)
        throw new Exception("Systemd/systemctl is not available in docker container.");
        
      if (output.IndexOf("Can't operate") > -1)
        throw new Exception("Error using docker");

    }

  }
}
