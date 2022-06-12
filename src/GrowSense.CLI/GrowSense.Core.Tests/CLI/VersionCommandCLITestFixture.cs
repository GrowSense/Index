using System;
using NUnit.Framework;

namespace GrowSense.Core.Tests.CLI
{
    [TestFixture]
    public class VersionCommandCLITestFixture : BaseTestFixture
    {
        [Test]
        public void VersionCommand()
        {
            MoveToTemporaryDirectory();

            PullDirectoryFromProject();

            var starter = new ProcessStarter();
            starter.WorkingDirectory = TemporaryDirectory;

            var mode = "Release";
#if DEBUG
            mode = "Debug";
#endif

            var upgradeCommand = "bash gs.sh version --mode=" + mode;

            starter.Start(upgradeCommand);

            Assert.IsFalse(starter.IsError, "An error occurred");

        }
    }
}
