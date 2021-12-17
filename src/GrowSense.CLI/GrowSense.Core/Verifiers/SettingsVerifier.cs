using System;
namespace GrowSense.Core.Verifiers
{
  public class SettingsVerifier : BaseVerifier
  {
    public SettingsVerifier(CLIContext context) : base(context)
    {
    }

    public void Verify()
    {
      VerifyLegacyFiles(Context.IndexDirectory);
    }
    
    public void VerifyLegacyFiles(string installDir)
    {
      AssertLegacySecurityFile("mqtt-username", Context.Settings.MqttUsername);
      AssertLegacySecurityFile("mqtt-password", Context.Settings.MqttPassword);
      AssertLegacySecurityFile("mqtt-port", Context.Settings.MqttPort.ToString());
      AssertLegacySecurityFile("mqtt-host", Context.Settings.MqttHost);
    }
  }
}
