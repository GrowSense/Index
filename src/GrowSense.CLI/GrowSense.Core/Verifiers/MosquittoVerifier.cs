using System;
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
      Console.WriteLine("Verifying MQTT docker service is running...");

      var logs = Docker.Logs(Context.MqttBrokerDockerContainerName);

      if (logs.IndexOf("running") == -1)
        throw new Exception("Mosquitto docker container is not running");
    }
    
  }
}
