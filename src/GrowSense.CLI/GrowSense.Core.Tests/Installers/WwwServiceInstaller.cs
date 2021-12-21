using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
using System.IO;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture(Category="Unit")]
  public class WwwServiceInstallerTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_Install()
    {

      MoveToTemporaryDirectory();

      PullDirectoryFromProject("/");

      File.WriteAllText(Path.GetFullPath("is-mock-systemctl.txt"), "true");

      var settings = new CLISettings();
      settings.IsMockSystemCtl = true;
      
      var context = new CLIContext(Environment.CurrentDirectory, settings);
      var installer = new WwwInstaller(context);
      installer.Verifier.SystemCtl = new MockSystemCtlHelper(context);

      installer.Install();
    }
    
  }
}
