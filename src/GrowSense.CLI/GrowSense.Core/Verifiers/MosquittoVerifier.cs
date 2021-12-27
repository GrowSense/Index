using System;
using System.IO;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Verifiers
{
  public class MosquittoVerifier
  {
    public DockerHelper Docker;
    public CLIContext Context;

    public MosquittoVerifier(CLIContext context)
    {
      Docker = new DockerHelper(context);
      Context = context;
    }

    public void Verify()
    {
      VerifyConfigFound();
      
      VerifyContainerRunning();
    }

    public void VerifyConfigFound()
    {
      Console.WriteLine("  Checking mosquitto config file exists...");
      
      var mosquittoPath = Context.Paths.GetApplicationPath("mosquitto");
      
      var configFile = Path.Combine(mosquittoPath, "data/mosquitto.conf");

      Console.WriteLine("    Path: " + configFile);

      if (!File.Exists(configFile))
        throw new FileNotFoundException(configFile);
      else
        Console.WriteLine("    Config file found");

      var content = File.ReadAllText(configFile);

      Console.WriteLine("");
      Console.WriteLine("----- Start Config File Content -----");
      Console.WriteLine(content);
      Console.WriteLine("----- End Config File Content -----");
      Console.WriteLine("");
    }
    
    public void VerifyContainerRunning()
    {
      Console.WriteLine("Verifying MQTT docker service is running...");

      if (!Docker.IsRunning("mosquitto"))
        throw new Exception("Mosquitto docker container is not running");
    }
  }
}
