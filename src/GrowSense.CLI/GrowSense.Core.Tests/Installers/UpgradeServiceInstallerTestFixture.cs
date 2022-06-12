using System;
using NUnit.Framework;
using GrowSense.Core.Installers;
using System.IO;
using GrowSense.Core.Tools.Mock;

namespace GrowSense.Core.Tests.Installers
{
    [TestFixture(Category = "Unit")]
    public class UpgradeServiceInstallerTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_Install()
        {

            MoveToTemporaryDirectory();

            PullDirectoryFromProject("/");

            File.WriteAllText(Path.GetFullPath("is-mock-systemctl.txt"), "true");

            var settings = new CLISettings();

            var context = new CLIContext(Environment.CurrentDirectory, settings);
            var mockSystemCtlHelper = new MockSystemCtlHelper(context);
            var installer = new UpgradeServiceInstaller(context);
            installer.SystemCtl = mockSystemCtlHelper;
            installer.Verifier.SystemCtl = mockSystemCtlHelper;

            installer.Install();
        }

    }
}
