using System;
using System.IO;
namespace GrowSense.Core
{
  public class CLIContext
  {
    public string MqttBrokerDockerContainerName = "mosquitto";
    
    public string ParentDirectory;
    public string IndexDirectory
    {
      get { return Path.Combine(ParentDirectory, "GrowSense/Index"); }
    }
    
    public CLISettings Settings;

    public PathHelper Paths;
    
    public CLIContext(string indexDirectory, CLISettings settings)
    {
      Paths = new PathHelper(this);
      Paths.Initialize(indexDirectory);
      
      Settings = settings;
    }
  }
}
