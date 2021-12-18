using System;
using GrowSense.Core.Installers;
using GrowSense.Core.Verifiers;
namespace GrowSense.Core.Installers
{
  public class PostInstaller
  {
    public ProcessStarter Starter = new ProcessStarter();
    public AptHelper Apt = new AptHelper();

    public PythonInstaller Python;
    public DockerInstaller Docker;
    public PlatformIOInstaller PlatformIO;
    public MosquittoInstaller Mqtt;
    public MqttBridgeInstaller MqttBridge;
    public UIControllerInstaller UIController;
    public ArduinoPlugAndPlayInstaller ArduinoPlugAndPlay;

    public Verifier Verifier;

    public string[] AptPackageList = new string[]{
    "build-essential",
    "curl",
    "wget",
    "git",
    "software-properties-common",
    "ca-certificates",
    "apt-transport-https",
    "xmlstarlet",
    "sshpass",
    "mosquitto-clients",
    "mosquitto",
    "zip",
    "unzip",
    "systemd" };
    
    public PostInstaller(CLIContext context)
    {
      Python = new PythonInstaller();
      Docker = new DockerInstaller(context);
      PlatformIO = new PlatformIOInstaller();
      Mqtt = new MosquittoInstaller(context);
      MqttBridge = new MqttBridgeInstaller(context);
      UIController = new UIControllerInstaller(context);
      ArduinoPlugAndPlay = new ArduinoPlugAndPlayInstaller(context);

      Verifier = new Verifier(context);
    }

    public void PrepareInstallation()
    {
      Console.WriteLine("Preparing installation...");
      
      ArduinoPlugAndPlay.ImportArduinoPlugAndPlayConfig();
      
      Apt.Update();
      Apt.Install(AptPackageList);

      Docker.Install();
      Python.Install();
      PlatformIO.Install();
      Mqtt.Install();
      MqttBridge.Install();
      UIController.Install();

      ArduinoPlugAndPlay.Install();

      Verifier.VerifyInstallation();
    }
    
    
  }
}
