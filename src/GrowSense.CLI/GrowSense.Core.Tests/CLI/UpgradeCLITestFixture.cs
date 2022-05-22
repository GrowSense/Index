using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Core.Tests.CLI
{
    [TestFixture]
    public class UpgradeCLITestFixture : BaseTestFixture
    {
        [Test]
        public void UpgradeCommand_UpgradesInstallerThenUsesItToUpgradeGrowSenseSystem()
        {
            MoveToTemporaryDirectory();

            PullDirectoryFromProject();

            var starter = new ProcessStarter();
            starter.WorkingDirectory = TemporaryDirectory;

            var mode = "Release";
#if DEBUG
            mode = "Debug";
#endif

            var upgradeCommand = "bash gs.sh upgrade --mode=" + mode + " --mock-systemctl=true --mock-docker=true";

            starter.Start(upgradeCommand);

            Assert.IsFalse(starter.IsError, "An error occurred");

            var installerDir = Path.GetFullPath(Directory.GetCurrentDirectory() + "/../Installer");
            Assert.IsTrue(Directory.Exists(installerDir));
            Assert.IsTrue(File.Exists(Directory.GetCurrentDirectory() + "/../Installer/GSInstaller.exe"));
        }
    }
}
