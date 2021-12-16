using System;
namespace GrowSense.Core
{
  public class CLIContext
  {
    public string MqttBrokerDockerContainerName = "mosquitto";
  
    public string WorkingDirectory;
    public CLISettings Settings;
    
    public CLIContext(string workingDirectory, CLISettings settings)
    {
      WorkingDirectory = workingDirectory;
      Settings = settings;
    }
  }
}
