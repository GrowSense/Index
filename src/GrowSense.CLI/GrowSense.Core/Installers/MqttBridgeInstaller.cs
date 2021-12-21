using System;
using GrowSense.Core.Verifiers;
using System.IO;
using System.Linq;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Installers
{
  public class MqttBridgeInstaller : BaseInstaller
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public DockerHelper Docker;
    public MqttBridgeVerifier Verifier;
    
    public MqttBridgeInstaller(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      Docker = new DockerHelper(context);
      Verifier = new MqttBridgeVerifier(context);
    }

    public void Install()
    {
      Console.WriteLine("Installing MQTT bridge...");
      
      var mqttBridgeInstallPath = Context.Paths.GetApplicationPath("BridgeArduinoSerialToMqttSplitCsv");

      Console.WriteLine("  Install path: " + mqttBridgeInstallPath);

      EnsureDirectoriesExist(mqttBridgeInstallPath);

      CopyFilesToInstallDir(mqttBridgeInstallPath);

      SetAppConfigValues();

      Verify(mqttBridgeInstallPath);
    }

    public void SetAppConfigValues()
    {
      Console.WriteLine("Setting MQTT bridge app config values...");
      
    var installedConfigPath = Context.Paths.GetApplicationPath("BridgeArduinoSerialToMqttSplitCsv") + "/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";

      Console.WriteLine("  Installed config path: " + installedConfigPath);

      var config = DeserializeAppConfig(installedConfigPath);

      config.AppSettings.Add.Where(e => e.Key == "Host").FirstOrDefault().Value = Context.Settings.MqttHost;
      config.AppSettings.Add.Where(e => e.Key == "UserId").FirstOrDefault().Value = Context.Settings.MqttUsername;
      config.AppSettings.Add.Where(e => e.Key == "Password").FirstOrDefault().Value = Context.Settings.MqttPassword;
      config.AppSettings.Add.Where(e => e.Key == "MqttPort").FirstOrDefault().Value = Context.Settings.MqttPort.ToString();
      
      config.AppSettings.Add.Where(e => e.Key == "SmtpServer").FirstOrDefault().Value = Context.Settings.SmtpServer;
      config.AppSettings.Add.Where(e => e.Key == "SmtpUsername").FirstOrDefault().Value = Context.Settings.SmtpUsername;
      config.AppSettings.Add.Where(e => e.Key == "SmtpPassword").FirstOrDefault().Value = Context.Settings.SmtpPassword;
      config.AppSettings.Add.Where(e => e.Key == "SmtpPort").FirstOrDefault().Value = Context.Settings.SmtpPort.ToString();
      config.AppSettings.Add.Where(e => e.Key == "EmailAddress").FirstOrDefault().Value = Context.Settings.Email;


      SerializeAppConfig(config, installedConfigPath);

      Console.WriteLine("Finished setting MQTT bridge app config values.");
    }

    public void EnsureDirectoriesExist(string mqttInstallPath)
    {
      if (!Directory.Exists(mqttInstallPath))
        Directory.CreateDirectory(mqttInstallPath);        
    }

    /*public void StartDockerContainer(string mosquittoInstallPath)
    {
      Console.WriteLine("  Starting mosquitto docker container...");

      Docker.Remove("mosquitto", true);

      var runCmd = String.Format(@"docker rm -f mosquitto
          docker run -d \
      --restart=always \
      --name=mosquitto \
      --volume {0}/data:/mosquitto/config \
      --network=host \
      -p 127.0.0.1:{1}:1883/tcp \
    eclipse-mosquitto",
    mosquittoInstallPath,
    Context.Settings.MqttPort
    );

      Docker.RunCommand(runCmd);
    }*/

    public void CopyFilesToInstallDir(string mqttBridgeInstallPath)
    {
      Console.WriteLine("  Copying files to install dir...");
      
      var internalPath = Context.IndexDirectory + "/scripts/apps/BridgeArduinoSerialToMqttSplitCsv";

      Console.WriteLine("    Internal path: " + internalPath);
      Console.WriteLine("    Install path: " + mqttBridgeInstallPath);

      var dirsToCopy = new string[] { "BridgeArduinoSerialToMqttSplitCsv" };

      var filesToCopy = new string[] { "BridgeArduinoSerialToMqttSplitCsv*.zip",
      "init.sh",
      "install-package-from-github-release.sh",
      "start-mqtt-bridge.sh"
      };

      CopyDirectories(internalPath, mqttBridgeInstallPath, dirsToCopy);

      CopyFiles(internalPath, mqttBridgeInstallPath, filesToCopy);
      
     /*var mqttInternalConfigPath = Path.GetFullPath(Context.WorkingDirectory + "/scripts/docker/mosquitto/data/mosquitto.conf");
      
      var mqttInstallConfigPath = mqttBridgeInstallPath + "/data/mosquitto.conf";
      Console.WriteLine("    From: " + mqttInternalConfigPath);
      Console.WriteLine("    To: " + mqttInstallConfigPath);

      if (!Directory.Exists(Path.GetDirectoryName(mqttInstallConfigPath)))
        Directory.CreateDirectory(Path.GetDirectoryName(mqttInstallConfigPath));

      File.Copy(mqttInternalConfigPath, mqttInstallConfigPath);*/
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

// TODO: Make it possible to enable this output but leave it disable by default. Exposes password to console
      //var content = File.ReadAllText(mqttInstallUserFilePath);
      
      //Console.WriteLine("    File content: " + content);

    }

    public void Verify(string mqttInstallPath)
    {
      Verifier.Verify();
    }
  }
}
