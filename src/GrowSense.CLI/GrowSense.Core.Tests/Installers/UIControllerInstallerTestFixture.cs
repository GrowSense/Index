using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture(Category="Unit")]
  public class UIControllerInstallerTestFixture : BaseTestFixture
  {
  [Test]
    public void Test_Install()
    {
      MoveToTemporaryDirectory();

      PullDirectoryFromProject("scripts/apps/Serial1602ShieldSystemUIController/");

      var random = new Random();

      var settings = new CLISettings();
      settings.MqttUsername = "user" + random.Next(1000, 9000);
      settings.MqttPassword = "pass" + random.Next(1000, 9000);
      settings.MqttHost = "10.0.0." + random.Next(0, 240);
      
      settings.SmtpServer = "smtp.myserver" + random.Next(1000, 9000) + ".com";
      settings.SmtpUsername = "user" + random.Next(1000, 9000);
      settings.SmtpPassword = "pass" + random.Next(1000, 9000);
      settings.Email = "me@mydomain" + random.Next(1000, 9000) + ".com";
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      var uiControllerInstaller = new UIControllerInstaller(context);

      uiControllerInstaller.Install();
    }
  }
}
