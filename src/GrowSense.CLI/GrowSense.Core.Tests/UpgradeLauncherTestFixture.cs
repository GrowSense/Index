using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Core.Tests
{
    [TestFixture]
    public class UpgraderLauncher : BaseTestFixture
    {
        [Test]
        public void Upgrade_UpgradesInstallerThenUsesItToUpgradeGrowSenseSystem()
        {
            MoveToTemporaryDirectory();

            PullDirectoryFromProject();

            var starter = new ProcessStarter();

            var mode = "Release";
#if DEBUG
            mode = "Debug";
#endif
            var context = new CLIContext(TemporaryDirectory, new CLISettings());

            var installPath = Path.GetFullPath("../");

            var upgrader = new UpgradeLauncher(context);

            upgrader.Upgrade();

            Assert.IsTrue(Directory.Exists(installPath + "/Installer"));
            Assert.IsTrue(File.Exists(installPath + "/Installer/GSInstaller.exe"));
        }
    }
}