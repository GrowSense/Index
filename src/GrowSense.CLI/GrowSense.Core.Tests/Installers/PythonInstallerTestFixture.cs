using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
namespace GrowSense.Core.Tests.Installers
{
[TestFixture]
  public class PythonInstallerTestFixture
  {
    [Test]
    public void Test_Install()
    {
      var pythonInstaller = new PythonInstaller();
      pythonInstaller.Install();
    }
  }
}
