using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
using System.IO;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture(Category="Unit")]
  public class SupervisorServiceInstallerTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_Install()
    {

      MoveToTemporaryDirectory();

      PullDirectoryFromProject("/");

      File.WriteAllText(Path.GetFullPath("is-mock-systemctl.txt"), "true");

      var random = new Random();

      var settings = new CLISettings();
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      var installer = new SupervisorInstaller(context);

      installer.Install();
    }
    
  }
}
