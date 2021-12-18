using System;
using System.IO;
using System.Threading;
using GrowSense.Core.Verifiers;
namespace GrowSense.Core.Installers
{
  public class MosquittoInstaller
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public DockerHelper Docker;
    public MosquittoVerifier Verifier;
    
    public MosquittoInstaller(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Docker = new DockerHelper(context);
      Verifier = new MosquittoVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing mosquitto MQTT docker service...");
      
      var mosquittoInstallPath = Path.GetFullPath(Context.IndexDirectory + "/../../mosquitto");

      Console.WriteLine("  Install path: " + mosquittoInstallPath);

      EnsureDirectoriesExist(mosquittoInstallPath);

      CopyConfigFileToInstallDir(mosquittoInstallPath);

      CreateUserFile(mosquittoInstallPath);

      StartDockerContainer(mosquittoInstallPath);

// Wait for container to start
      Thread.Sleep(1000);

      Verify(mosquittoInstallPath);
    }

    public void EnsureDirectoriesExist(string mqttInstallPath)
    {
      if (!Directory.Exists(mqttInstallPath))
        Directory.CreateDirectory(mqttInstallPath);
        
      if (!Directory.Exists(mqttInstallPath + "/data"))
        Directory.CreateDirectory(mqttInstallPath + "/data");
        
    }

    public void StartDockerContainer(string mosquittoInstallPath)
    {
      Console.WriteLine("  Starting mosquitto docker container...");

      Docker.Remove("mosquitto", true);

      Starter.StartBash("chown -R $USER " + mosquittoInstallPath);

      var runCmd = String.Format(@"sudo docker run -d \
        --privileged \
        --restart=always \
        --name=mosquitto \
        --volume {0}/data:/mosquitto/config \
        --network=host \
        -p 127.0.0.1:{1}:1883/tcp \
        -p 9001:9001 \
        eclipse-mosquitto",
        mosquittoInstallPath,
        Context.Settings.MqttPort
      );

      Console.WriteLine("  Mosquitto docker command:");
      Console.WriteLine("    " + runCmd);

      Docker.RunCommand(runCmd);
    }

    public void CopyConfigFileToInstallDir(string mqttInstallPath)
    {
      Console.WriteLine("  Copying config file to install dir...");
      
      var mqttInternalConfigPath = Path.GetFullPath(Context.IndexDirectory + "/scripts/docker/mosquitto/data/mosquitto.conf");
      
      var mqttInstallConfigPath = mqttInstallPath + "/data/mosquitto.conf";
      Console.WriteLine("    From: " + mqttInternalConfigPath);
      Console.WriteLine("    To: " + mqttInstallConfigPath);

      if (!Directory.Exists(Path.GetDirectoryName(mqttInstallConfigPath)))
        Directory.CreateDirectory(Path.GetDirectoryName(mqttInstallConfigPath));

      File.Copy(mqttInternalConfigPath, mqttInstallConfigPath, true);
    }

    public void CreateUserFile(string mqttInstallPath)
    {
      Console.WriteLine("  Creating user file...");
      var mqttInstallUserFilePath = mqttInstallPath + "/data/mosquitto.userfile";

      Console.WriteLine("    Path: " + mqttInstallUserFilePath);
      Console.WriteLine("    Username: " + Context.Settings.MqttUsername);
      Console.WriteLine("    Password: " + Context.Settings.MqttPassword);

      File.WriteAllText(mqttInstallUserFilePath, "");

      var cmd = String.Format("mosquitto_passwd -b \"{0}\" \"{1}\" \"{2}\"",
       mqttInstallUserFilePath,
       Context.Settings.MqttUsername,
       Context.Settings.MqttPassword
       );
       

      Starter.StartBash(cmd);

      var content = File.ReadAllText(mqttInstallUserFilePath);
      
      Console.WriteLine("    File content: " + content);

    }

    public void Verify(string mqttInstallPath)
    {
      Verifier.Verify();
    }
  }
}
