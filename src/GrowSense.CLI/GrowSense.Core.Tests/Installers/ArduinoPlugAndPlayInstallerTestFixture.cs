﻿using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
using System.IO;
using GrowSense.Core.Tools.Mock;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture(Category="Unit")]
  public class ArduinoPlugAndPlayInstallerTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_Install()
    {
      MoveToTemporaryDirectory();

      var random = new Random();

      var settings = new CLISettings();
      
      settings.SmtpServer = "smtp.myserver" + random.Next(1000, 9000) + ".com";
      settings.SmtpUsername = "user" + random.Next(1000, 9000);
      settings.SmtpPassword = "pass" + random.Next(1000, 9000);
      settings.Email = "me@mydomain" + random.Next(1000, 9000) + ".com";
      settings.IsMockSystemCtl = true;
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      
      var installer = new ArduinoPlugAndPlayInstaller(context);
      installer.Verifier.SystemCtl = new MockSystemCtlHelper(context);

      installer.EnsureInstallDirectoryExists();
      
      var installPath = installer.GetInstallPath();
      
      //File.WriteAllText(Path.Combine(installPath, "is-mock-systemctl.txt"), "true");

      installer.Install();

      //var starter = new ProcessStarter();
      
      //starter.StartBash("sudo systemctl disable arduino-plug-and-play.service");
      //starter.StartBash("sudo systemctl stop arduino-plug-and-play.service");
    }
  }
}
