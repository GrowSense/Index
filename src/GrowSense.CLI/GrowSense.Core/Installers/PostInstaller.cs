using System;
using GrowSense.Core.Installers;
using GrowSense.Core.Verifiers;
using System.IO;
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

        public SupervisorInstaller Supervisor;
        public UpgradeServiceInstaller UpgradeService;
        public WwwInstaller WWW;

        public Verifier Verifier;

        public CLIContext Context;

        public SettingsManager SettingsManager;

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

        public string[] OtherCommands = new string[]{

    };

        public PostInstaller(CLIContext context)
        {
            Context = context;

            Python = new PythonInstaller();
            Docker = new DockerInstaller(context);
            PlatformIO = new PlatformIOInstaller();
            Mqtt = new MosquittoInstaller(context);
            MqttBridge = new MqttBridgeInstaller(context);
            UIController = new UIControllerInstaller(context);
            ArduinoPlugAndPlay = new ArduinoPlugAndPlayInstaller(context);

            Supervisor = new SupervisorInstaller(context);
            UpgradeService = new UpgradeServiceInstaller(context);
            WWW = new WwwInstaller(context);

            SettingsManager = new SettingsManager(context.IndexDirectory);

            Verifier = new Verifier(context);
        }

        public void PrepareInstallation()
        {
            Console.WriteLine("Preparing installation...");

            CreateMockFiles();

            Apt.Update();
            Apt.Starter.EnableErrorCheckingByTextMatching = false; // Disabled error checking because it causes false positives
            Apt.Install(AptPackageList);

            Docker.Install();
            Python.Install();
            PlatformIO.Install();
            Mqtt.Install();
            MqttBridge.Install();
            UIController.Install();

            ArduinoPlugAndPlay.Install();

            Supervisor.Install();
            UpgradeService.Install();
            WWW.Install();

            foreach (var command in OtherCommands)
            {
                Starter.StartBash(command);
            }

            SettingsManager.SaveSettings(Context.Settings);

            Verifier.VerifyInstallation();

        }

        public void CreateMockFiles()
        {
            if (Context.Settings.IsMockSystemCtl)
                File.CreateText(Context.IndexDirectory + "/is-mock-systemctl.txt");
        }
    }
}