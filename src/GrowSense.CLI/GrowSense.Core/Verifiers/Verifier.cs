using System;
using System.IO;
using GrowSense.Core.Verifiers;
namespace GrowSense.Core.Verifiers
{
    public class Verifier : BaseVerifier
    {
        public DockerVerifier Docker;

        public MosquittoVerifier Mosquitto;

        public MqttBridgeVerifier MqttBridge;
        public UIControllerVerifier UIController;

        public ArduinoPlugAndPlayVerifier ArduinoPlugAndPlay;

        public SettingsVerifier Settings;

        public SupervisorVerifier Supervisor;
        public UpgradeServiceVerifier UpgradeService;
        public WwwVerifier WWW;

        public VersionVerifier Version;


        public Verifier(CLIContext context) : base(context)
        {
            Context = context;
            Docker = new DockerVerifier(context);

            ArduinoPlugAndPlay = new ArduinoPlugAndPlayVerifier(context);

            Mosquitto = new MosquittoVerifier(context);
            MqttBridge = new MqttBridgeVerifier(context);
            UIController = new UIControllerVerifier(context);

            Settings = new SettingsVerifier(context);

            Supervisor = new SupervisorVerifier(context);
            UpgradeService = new UpgradeServiceVerifier(context);
            WWW = new WwwVerifier(context);

            Version = new VersionVerifier(context);

            Console.WriteLine("GrowSense installation verified");
        }

        public void VerifyInstallation()
        {
            Console.WriteLine("Verifying installation...");

            WaitForPlugAndPlay();

            Docker.Verify();

            ArduinoPlugAndPlay.Verify();

            Mosquitto.Verify();

            MqttBridge.Verify();

            UIController.Verify();

            Supervisor.Verify();

            UpgradeService.Verify();

            Version.Verify();
        }

        public void WaitForPlugAndPlay()
        {
            Starter.EnableErrorCheckingByTextMatching = false;
            Starter.StartBash("bash wait-for-plug-and-play.sh");
            Starter.EnableErrorCheckingByTextMatching = true;
        }


    }
}