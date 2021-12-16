using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
using System.IO;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture]
  public class ArduinoPlugAndPlayInstallerTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_Install()
    {
      MoveToTemporaryDirectory();

      //PullFileFromProject("scripts/docker/mosquitto/data/mosquitto.conf");

      var random = new Random();

      var settings = new CLISettings();
      settings.SmtpServer = "smtp.server" + random.Next(1000, 9000) + ".com";
      settings.SmtpUsername = "user" + random.Next(1000, 9000);
      settings.SmtpPassword = "pass" + random.Next(1000, 9000);
      settings.SmtpPort = random.Next(100, 999);
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      var installer = new ArduinoPlugAndPlayInstaller(context);

      installer.EnsureInstallDirectoryExists();
      
      var installPath = installer.GetInstallPath();
      
      File.WriteAllText(Path.Combine(installPath, "is-mock-systemctl.txt"), "true");

      installer.Install();

      var starter = new ProcessStarter();
      starter.StartBash("sudo systemctl disable arduino-plug-and-play.service");
      starter.StartBash("sudo systemctl stop arduino-plug-and-play.service");
    }
  }
}
