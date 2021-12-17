using System;
using System.IO;
using GrowSense.Core.Verifiers;
namespace GrowSense.Core.Verifiers
{
  public class Verifier : BaseVerifier
  {
    public DockerVerifier Docker;
    public ProcessStarter Starter;

    public MosquittoVerifier Mosquitto;

    public MqttBridgeVerifier MqttBridge;
    public UIControllerVerifier UIController;

    public ArduinoPlugAndPlayVerifier ArduinoPlugAndPlay;

    public SettingsVerifier Settings;
    
    
    public Verifier(CLIContext context) : base(context)
    {
      Context = context;
      Docker = new DockerVerifier(context);
      Starter = new ProcessStarter(context.IndexDirectory);

      ArduinoPlugAndPlay = new ArduinoPlugAndPlayVerifier(context);

      Mosquitto = new MosquittoVerifier(context);
      MqttBridge = new MqttBridgeVerifier(context);
      UIController = new UIControllerVerifier(context);

      Settings = new SettingsVerifier(context);
    }

    public void VerifyInstallation()
    {
      Docker.Verify();
      
      ArduinoPlugAndPlay.Verify();

      Mosquitto.Verify();
     
      MqttBridge.Verify();

      UIController.Verify();
    }

    


  }
}
