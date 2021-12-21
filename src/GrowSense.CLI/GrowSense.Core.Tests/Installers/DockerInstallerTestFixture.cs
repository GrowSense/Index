using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
using GrowSense.Core.Tools.Mock;

namespace GrowSense.Core.Tests.Installers
{
  [TestFixture(Category = "Unit")]
  public class DockerInstallerTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_Install()
    {
      MoveToTemporaryDirectory();
      
      var context = new CLIContext(Environment.CurrentDirectory, new CLISettings());
      
      var installer = new DockerInstaller(context);
      installer.Verifier.SystemCtl = new MockSystemCtlHelper(context);
      installer.Install();
    }
  }
}
