using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture]
  public class UIControllerInstallerTestFixture : BaseTestFixture
  {
  [Test]
    public void Test_Install()
    {
      MoveToTemporaryDirectory();

      PullDirectoryFromProject("scripts/apps/Serial1602ShieldSystemUIController/");

      var random = new Random();

      var settings = new CLISettings();
      //settings.MqttUsername = "user" + random.Next(1000, 9000);
      //settings.MqttPassword = "pass" + random.Next(1000, 9000);
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      var uiControllerInstaller = new UIControllerInstaller(context);

      uiControllerInstaller.Install();
    }
  }
}
