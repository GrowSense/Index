using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture(Category="Unit")]
  public class PlatformIOInstallerTestFixture
  {
  [Test]
    public void Test_Install()
    {
      var installer = new PlatformIOInstaller();
      installer.Install();
    }
  }
}
