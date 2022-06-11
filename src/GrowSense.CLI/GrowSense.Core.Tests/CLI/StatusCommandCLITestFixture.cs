using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Core.Tests.CLI
{
    [TestFixture]
    public class StatusCommandCLITestFixture : BaseTestFixture
    {
        [Test]
        public void StatusCommand()
        {
            MoveToTemporaryDirectory();

            PullDirectoryFromProject();

            var starter = new ProcessStarter();
            starter.WorkingDirectory = TemporaryDirectory;

            var mode = "Release";
#if DEBUG
            mode = "Debug";
#endif

            var status = "bash gs.sh status --mode=" + mode + " --mock-systemctl=true --mock-docker=true";

            starter.Start(status);

            Assert.IsFalse(starter.IsError, "An error occurred");

            Assert.IsTrue(starter.Output.Contains("Version:"));

        }
    }
}
