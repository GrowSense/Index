using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture]
  public class MqttBridgeInstallerTestFixture : BaseTestFixture
  {
  [Test]
    public void Test_Install()
    {
      MoveToTemporaryDirectory();

      PullDirectoryFromProject("scripts/apps/BridgeArduinoSerialToMqttSplitCsv/");

      var random = new Random();

      var settings = new CLISettings();
      settings.MqttUsername = "user" + random.Next(1000, 9000);
      settings.MqttPassword = "pass" + random.Next(1000, 9000);
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      var mqttBridgeInstaller = new MqttBridgeInstaller(context);

      mqttBridgeInstaller.Install();
    }
  }
}
