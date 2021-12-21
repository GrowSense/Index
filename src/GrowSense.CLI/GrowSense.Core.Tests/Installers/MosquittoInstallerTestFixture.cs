using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
using GrowSense.Core.Tools.Mock;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture(Category="Unit")]
  public class MosquittoInstallerTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_Install()
    {
      MoveToTemporaryDirectory();

      PullFileFromProject("scripts/docker/mosquitto/data/mosquitto.conf");

      var random = new Random();

      var settings = new CLISettings();
      settings.MqttUsername = "user" + random.Next(1000, 9000);
      settings.MqttPassword = "pass" + random.Next(1000, 9000);
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      var mosquittoInstaller = new MosquittoInstaller(context);
      mosquittoInstaller.Docker = new MockDockerHelper(context);
      mosquittoInstaller.Verifier.Docker = mosquittoInstaller.Docker;

      mosquittoInstaller.Install();

      mosquittoInstaller.Docker.Remove("mosquitto", true);
    }
  }
}
