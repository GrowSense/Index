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
      VerifyUserFile();
    
      VerifyConfig();
      
      VerifyContainerRunning();
    }
    
    public void VerifyUserFile()
    {
      Console.WriteLine("  Checking mosquitto userfile...");
      
      var mosquittoPath = Context.Paths.GetApplicationPath("mosquitto");
      
      var userFile = Path.Combine(mosquittoPath, "data/mosquitto.userfile");

      Console.WriteLine("    Path: " + userFile);

      if (!File.Exists(userFile))
        throw new FileNotFoundException(userFile);
      else
        Console.WriteLine("    Mosquitto userfile found");

      var content = File.ReadAllText(userFile);

      Console.WriteLine("");
      Console.WriteLine("----- Start User File Content -----");
      Console.WriteLine(content);
      Console.WriteLine("----- End User File Content -----");
      Console.WriteLine("");
      
      if (content.IndexOf(Context.Settings.MqttUsername) == -1)
        throw new Exception("MQTT username not found in mosquitto.userfile");
    }
    

    public void VerifyConfig()
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
